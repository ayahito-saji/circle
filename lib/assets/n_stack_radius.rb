class NStackRadius
  require_relative 'n_stack_radius_parser'
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
      if user
        puts "USER #{user[:model].name}"
      end

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
              user[:status][:screen] += "#{arguments[1][1][0][1]}<br>"
              UserChannel.broadcast_to(user[:model], "$('body').html(\"#{user[:status][:screen]}\")")
              stack.push([:null, nil, 0])
          end

        when :assign_variable
          @status[:room][:status][:variable_env][arguments[0][1]] = arguments[1]
          stack.push(arguments[1])
        when :reference_variable
          stack.push(@status[:room][:status][:variable_env][arguments[0][1]])

        when :goto
          operators = @status[:room][:status][:phase_env][arguments[0][1]].clone
          stack = []

        when :phase
          # puts "フェイズ名:#{arguments[0][1][0]} フェイズ内容:#{data[0]}"
          # puts "@status = #{@status[:room][:status][:phase_env]}"
          @status[:room][:status][:phase_env][arguments[0][1]] = data
          stack.push([:null, nil, 0])

        when :do
          do_users = @status[:users]
          do_users.each do |user|
            user[:status][:stack] = []
            user[:status][:operators] = data.clone
          end
          stack.push([:null, nil, 0])
          return

        else
          stack.push([:null, nil, 0])

      end
      puts "STACK #{stack}"
      puts ""
    end
    stack.pop()
#    puts "PHASE DATA"
#    pp @status[:room][:status][:phase_env]
    puts "VARIABLE ENVERONMENT"
    pp @status[:room][:status][:variable_env]
  end

  def run(pushed_user, pushed_data)
    # {order: 'run', rulebook: ルールブックID}
    if pushed_data['order'] == 'start' # 開始
      if @status[:room][:status][:running] == true
        return
      end
      rulebook = Rulebook.find_by(id: pushed_data['rulebook'])

      # 構文解析
      operators = analysis(rulebook.code)

      @status[:room][:status][:phase_env] = {}
      @status[:room][:status][:variable_env] = {}

      # フェイズ構造を取得
      do_operators(operators, [], nil)
      if @status[:room][:status][:phase_env]['main'].nil?
        UserChannel.broadcast_to(pushed_user, "alert('ルールブックエラー: mainフェイズが見つかりません.');")
        return
      end

      # 画面の初期化、ユーザーオペレータの設定
      @status[:users].each do |user|
        user[:status][:stack] = []
        user[:status][:operators] = []
        user[:status][:screen] = "<h1>#{rulebook.title}</h1><p><button onclick=App.user.push({'order':'end'})>Quit</button></p>"
        user[:status][:active] = true
        user[:status][:action_auth] = ""
        UserChannel.broadcast_to(user[:model], "$('body').html(\"#{user[:status][:screen]}\")")
      end
      # 状況の保存
      @status[:room][:status][:running] = true
      @status[:room][:status][:stack] = []
      @status[:room][:status][:operators] = @status[:room][:status][:phase_env]['main'].clone
    end
    if pushed_data['order'] == 'end'
      @status[:room][:status][:running] = false
      return
    end
    p "MAIN LOOP"
    puts "@status = #{@status}"
    while true
      # メインフェイズの実行
      do_operators(@status[:room][:status][:operators], @status[:room][:status][:stack], nil)
      # ユーザーフェイズの実行
      @status[:users].each do |user|
        puts "USER PHASE: #{user[:model][:name]}"
        do_operators(user[:status][:operators], user[:status][:stack], user)
      end
      break if @status[:room][:status][:operators].empty?
      break if !all_users_operators_empty?
    end
  end

  def setStatus(room)
    @status = {
        room: {
            model: Room.find(room.id)
        }
    }
    @status[:room][:status] = {
        running:      @status[:room][:model].running,
        phase_env:    @status[:room][:model].phase_env,
        variable_env: @status[:room][:model].variable_env,
        operators:    @status[:room][:model].operators,
        stack:        @status[:room][:model].stack
    }
    @status[:users] = []
    @status[:room][:model].users.each do |user|
      buf = {
          model:      User.find(user.id)
      }
      buf[:status] = {
          stack:      buf[:model].stack,
          operators:  buf[:model].operators,
          active:     buf[:model].active,
          action_auth:buf[:model].action_auth
      }
      @status[:users] << buf
    end
    puts "@status = #{@status}"
  end
  def saveStatus
    @status[:room][:model].update_attributes(@status[:room][:status])
    @status[:users].each do |user|
      user[:model].update_attributes(user[:status])
    end
  end
  private

  def all_users_operators_empty?
    all_users_operators_empty = true
    @status[:users].each do |user|
      if user[:status][:operators] == false
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