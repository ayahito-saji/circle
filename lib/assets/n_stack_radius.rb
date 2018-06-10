class NStackRadius
  require_relative 'n_stack_radius_parser'
  attr_accessor :room
  attr_reader :variable_environment
  attr_reader :phase_environment
  def initialize
    @variable_environment = {}
    @phase_environment = {}
  end
  def analysis(rulebook)
    parser = NStackRadiusParser.new
    parser.parse(rulebook)
  end
  def do_operators(operators, stack, user)
    while operators.length > 0
      operator = operators.pop
      puts "OPERATOR #{operator}"
      arguments = stack.pop(operator[2]) # オペレータで使用する変数
      data = operator[1]                         # オペレータで使用する定数
      puts "ARGUMENTS #{arguments}"
      puts "CONSTANT #{data}"

      case operator[0] # オペレータ種類

        when :identifier
          stack.push(operator)
        when :number
          stack.push(operator)
        when :string
          stack.push(operator)
        when :boolean
          stack.push(operator)

        when :add
          stack.push([:number, arguments[0][1] + arguments[1][1], 0])
        when :dif
          stack.push([:number, arguments[0][1] - arguments[1][1], 0])
        when :mul
          stack.push([:number, arguments[0][1] * arguments[1][1], 0])
        when :div
          stack.push([:number, arguments[0][1] / arguments[1][1], 0])
        when :mod
          stack.push([:number, arguments[0][1] % arguments[1][1], 0])

        when :arguments
          stack.push([:arguments, arguments, 0])
        when :call_function
          case arguments[0][1]
            when "print"
              user.screen = user.screen += "#{arguments[1][1][0][1]}<br>"
              UserChannel.broadcast_to(user, "$('body').html(\"#{user.screen}\")")
              user.save!
              stack.push([:null, nil, 0])
          end

        when :assign_variable
          @variable_environment[arguments[0][1]] = arguments[1]
          stack.push(arguments[1])
        when :reference_variable
          stack.push(@variable_environment[arguments[0][1]])

        when :goto
          operators = @phase_environment[arguments[0][1]].clone
          stack = []

        when :phase
          # puts "フェイズ名:#{arguments[0][1][0]} フェイズ内容:#{data[0]}"
          @phase_environment[arguments[0][1]] = data
          stack.push([:null, nil, 0])

        when :do
          do_users = @room.users
          if arguments[0][1] == "ActiveUser"
            do_users = @room.users.where(active: true)
          end
          do_users.each do |user|
            user.update_attributes({
                                       stack: [],
                                       operators: data,
                                   })
          end
          stack.push([:null, nil, 0])
          return [operators, stack]

        else
          stack.push([:null, nil, 0])

      end
      puts "STACK #{stack}"
      puts ""
    end
    stack.pop()
#    puts "PHASE DATA"
#    pp @phase_environment
    puts "VARIABLE ENVERONMENT"
    pp @variable_environment
    return [operators, stack]
  end

  def run(pushed_user, pushed_data)
    # {order: 'run', rulebook: ルールブックID}
    if pushed_data['order'] == 'run' # 開始
      rulebook = Rulebook.find_by(id: pushed_data['rulebook'])

      # 構文解析
      operators = analysis(rulebook.code)
      # マスターオペレーターの設定
      operators, stack = do_operators(operators, [], nil)
      if phase_environment['main'].nil?
        UserChannel.broadcast_to(pushed_user, "alert('ルールブックエラー: mainフェイズが見つかりません.');")
        return
      end

      # 画面の初期化、ユーザーオペレータの設定
      @room.users.each do |user|
        user.update_attributes({
                                   stack: [],
                                   operators: [],
                                   screen: "<h1>#{rulebook.title}</h1>",
                                   active: true,
                                   action_auth: ""
                               })
        UserChannel.broadcast_to(user, "$('body').html(\"#{user.screen}\")")
      end
      # 状況の保存
      @room.update_attributes({
                                  phase_env: @phase_environment,
                                  variable_env: @variable_environment,
                                  operators: @phase_environment['main'].clone,
                                  stack: []
                             })
    end
    if pushed_data['order'] == 'end'

    end

    while true
      # メインフェイズの実行
      operators, stack = do_operators(@room.operators, @room.stack, nil)
      @room.update_attributes({
                                  phase_env: @phase_environment,
                                  variable_env: @variable_environment,
                                  operators: operators,
                                  stack: stack
                              })
      # ユーザーフェイズの実行
      @room.users.each do |user|
        user = User.find_by(id: user.id)
        operators, stack = do_operators(user.operators, user.stack, user)
        user.update_attributes({
                                   stack: stack,
                                   operators: operators,
                               })
        @room.update_attributes({
                                    phase_env: @phase_environment,
                                    variable_env: @variable_environment,
                                })
      end
      break if @room.operators.empty?
      break if !all_users_operators_empty?
    end
  end

  private

  def all_users_operators_empty?
    all_users_operators_empty = true
    @room.users.each do |user|
      user = User.find_by(id: user.id)
      if user.operators.empty? == false
        all_users_operators_empty = false
        break
      end
    end
    all_users_operators_empty
  end
end

if __FILE__ == $0
  radius = NStackRadius.new
  prg = ""
  File.open("program.rlb", "r") do |f|
    prg = f.read.chomp
  end
  operators = radius.analysis(prg)
  radius.do_operators(operators, [], nil)
  radius.do_operators(radius.phase_environment['main'].clone, [], nil)
end