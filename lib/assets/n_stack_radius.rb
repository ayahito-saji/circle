class NStackRadius
  require_relative 'n_stack_radius_parser'
  require 'securerandom'
  attr_accessor :status
  def analysis(rulebook)
    parser = NStackRadiusParser.new
    parser.parse(rulebook)
  end
  def do_operators(operators, stack, user, pushed_data)
    while operators.length > 0
      operator = operators.pop
      puts (user ? "USER #{user[:model].name}" : "CENTRAL")
      puts "OPERATOR #{operator}"
      puts "OPERATORS #{operators.to_s}"
      arguments = stack.pop(operator[2]) # オペレータで使用する変数
      data = operator[1]                 # オペレータで使用する定数
      puts "ARGUMENTS #{arguments}"
      puts "DATA #{data}"
      puts "STACK #{stack}"

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
          if arguments[0][0] == :number && arguments[1][0] == :number
            stack.push([:number, arguments[0][1] + arguments[1][1], 0])
          elsif (arguments[0][0] == :string && arguments[1][0] == :number) || (arguments[0][0] == :number && arguments[1][0] == :string)
            stack.push([:string, arguments[0][1].to_s + arguments[1][1].to_s, 0])
          elsif arguments[0][0] == :string && arguments[1][0] == :string
            stack.push([:string, arguments[0][1] + arguments[1][1], 0])
          end
        when :dif
          stack.push([:number, arguments[0][1] - arguments[1][1], 0])
        when :mul
          stack.push([:number, arguments[0][1] * arguments[1][1], 0])
        when :div
          stack.push([:number, arguments[0][1] / arguments[1][1], 0])
        when :mod
          stack.push([:number, arguments[0][1] % arguments[1][1], 0])

        when :index
          if arguments[0][0] == :array || arguments[0][0] == :hash
            key = arguments[1][1]
            value = arguments[0][1][key]
            value = [:null, nil, 0] if value.nil?
            stack.push(value)
          end
        when :arguments
          stack.push([:arguments, arguments, 0])
        when :key_values
          key_values = []
          (arguments.length / 2).times do |i|
            key_values << [arguments[i * 2], arguments[i * 2 + 1]]
          end
          stack.push([:key_values, key_values, 0])
        when :define_array
          array = []
          if !arguments.empty?
            array = arguments[0][1]
          end
          stack.push([:array, array, 0])

        when :define_hash
          hash = {}
          if !arguments.empty?
            arguments[0][1].each do |key_value|
              hash[key_value[0][1]] = key_value[1]
            end
          end
          stack.push([:hash, hash, 0])
        when :call_function
          case arguments[0][1]
            when "print"
              user[:status][:screen] += "#{arguments[1][1][0][1]}<br>"
              broadcast_to user, "$('#screen').html(\"#{user[:status][:screen]}\");"
              stack.push([:null, nil, 0])
            when "textbox"
              user[:status][:screen] += "<input type=text data-auth=#{user[:status][:action_auth]}><br/>"
            when "button"
              user[:status][:screen] += "<button onclick=Input.click_button(this) data-auth=#{user[:status][:action_auth]}>#{arguments[1][1][0][1]}</button><br/>"
              broadcast_to user, "$('#screen').html(\"#{user[:status][:screen]}\");"
              stack.push([:null, nil, 0])
            when "input"
              operators.push([:inputted, nil, 0])
              return
          end

        when :inputted
          if pushed_data
            puts "***INPUT AUTH START***"
            puts "USER #{user[:model].name}" if user
            puts "DATA #{pushed_data}"
            puts "VERIFY AUTH TOKEN: #{user[:status][:action_auth]}"
            puts "***INPUT AUTH END***"
          end
          if pushed_data && pushed_data['value'] && pushed_data['action_auth'] == user[:status][:action_auth]
            stack.push([:string, pushed_data['value'], 0])
            user[:status][:action_auth] = SecureRandom.urlsafe_base64
          else
            operators.push(operator)
            return
          end
        when :assign_variable
          # 変数環境
          if arguments[0][0] == :variable_env
            env = @status[:room][:status][:variable_env]
          elsif arguments[0][0] == :array || arguments[0][0] == :hash
            env = arguments[0][1]
          end
          # 変数保存
          if arguments[0][0] == :array
            (arguments[1][1] - env.length).times do
              env << [:null, nil, 0]
            end
            env[arguments[1][1]] = arguments[2]
          elsif arguments[0][0] == :hash || arguments[0][0] == :variable_env
            env[arguments[1][1]] = arguments[2]
          end
          # pp @status[:room][:status][:variable_env]
          stack.push(arguments[2])
        when :reference_variable
          # pp @status[:room][:status][:variable_env]
          stack.push(@status[:room][:status][:variable_env][arguments[0][1]])
        when :variable_env
          stack.push([:variable_env, nil, nil])
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
          do_users.each_value do |user|
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
    puts "*** RUN ***"
    # {order: 'run', rulebook: ルールブックID}
    if pushed_data['order'] == 'start' # 開始
      return if @status[:room][:status][:running] == true

      rulebook = Rulebook.find_by(id: pushed_data['rulebook'])

      # 構文解析
      operators = analysis(rulebook.code)

      @status[:room][:status][:phase_env] = {}
      @status[:room][:status][:variable_env] = {}

      # フェイズ構造を取得
      do_operators(operators, [], nil, nil)
      if @status[:room][:status][:phase_env]['main'].nil?
        return
      end

      # 画面の初期化、ユーザーオペレータの設定
      @status[:users].each_value do |user|
        user[:status][:stack] = []
        user[:status][:operators] = []
        user[:status][:screen] = "<h1>#{rulebook.title}</h1><p><button onclick=App.user.push({'order':'end'})>Quit</button></p>"
        user[:status][:active] = true
        user[:status][:action_auth] = SecureRandom.urlsafe_base64
        broadcast_to user, "$('#screen').html(\"#{user[:status][:screen]}\");"
      end
      # 状況の保存
      @status[:room][:status][:running] = true
      @status[:room][:status][:stack] = []
      @status[:room][:status][:operators] = @status[:room][:status][:phase_env]['main'].clone
    elsif pushed_data['order'] == 'onload'
      return if @status[:room][:status][:running] == false
      user = @status[:users][pushed_user.id]
      broadcast_to user, "$('#screen').html(\"#{user[:status][:screen]}\");"

      return
    elsif pushed_data['order'] == 'action'
      user = @status[:users][pushed_user.id]
      do_operators(user[:status][:operators], user[:status][:stack], user, pushed_data)

    elsif pushed_data['order'] == 'end'
      return if @status[:room][:status][:running] == false
      @status[:room][:status][:running] = false
      self.saveStatus
      @status[:users].each_value do |user|
        broadcast_to user, "location.href='/';"
      end
      return
    end
    while true
      # メインフェイズの実行
      if all_users_operators_empty?
        puts "*** CENTRAL PHASE ***"
        do_operators(@status[:room][:status][:operators], @status[:room][:status][:stack], nil, nil)
      end
      # ユーザーフェイズの実行
      @status[:users].each_value do |user|
        puts "*** USER PHASE #{user[:model][:name]} ***"
        do_operators(user[:status][:operators], user[:status][:stack], user, nil)
      end
      break if @status[:room][:status][:operators].empty?
      break if !all_users_operators_empty?
    end

    # デバッグ用通知
    @status[:users].each_value do |user|
      broadcast_to user, ""
    end

  end

  # 各デバイスのフロントで実行されるプログラムを渡します。

  def broadcast_to(user, value)
    @status[:room][:status][:broadcast_id] += 1
    # DeliverScriptJob.perform_later(user[:model], value, @status[:room][:status][:broadcast_id])

    debug_code = "<h3>Operators</h3>"
    debug_code += "<table border><tr>"
    debug_code += "<th>Room</th>"
    @status[:users].each_value { |user| debug_code += "<th>#{user[:model].name}</th>"}
    debug_code += "</tr><tr><td></td>"
    @status[:users].each_value { |user| debug_code += "<td>#{user[:status][:action_auth]}</td>"}
    debug_code += "</tr><tr>"
    debug_code += "<td valign=top>"
    # @status[:room][:status][:operators].reverse.each { |operator| debug_code += "<>#{operator[0].to_s}</b><br>#{operator[1].to_s}<br/>"}
    debug_code += @status[:room][:status][:operators].to_s
    debug_code += "</td>"
    @status[:users].each_value do |user|
      debug_code += "<td valign=top>"
      # user[:status][:operators].reverse.each { |operator| debug_code += "<b>#{operator[0].to_s}</b><br>#{operator[1].to_s}<br/>"}
      debug_code += user[:status][:operators].to_s
      debug_code += "</td>"
    end
    debug_code += "</tr></table>"
    debug_code += "#{@status[:room][:status][:broadcast_id]}"
    DeliverScriptJob.perform_later(user[:model], "#{value}$('#debug').html('#{debug_code}');", @status[:room][:status][:broadcast_id])
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
        stack:        @status[:room][:model].stack,
        broadcast_id: @status[:room][:model].broadcast_id
    }
    @status[:users] = {}
    @status[:room][:model].users.each do |user|
      buf = {
          model:      User.find(user.id)
      }
      buf[:status] = {
          stack:      buf[:model].stack,
          operators:  buf[:model].operators,
          active:     buf[:model].active,
          action_auth:buf[:model].action_auth,
          screen:     buf[:model].screen
      }
      @status[:users][buf[:model].id] = buf
    end
    puts "@status = #{@status}"
  end
  def saveStatus
    @status[:room][:model].update_attributes(@status[:room][:status])
    @status[:users].each_value do |user|
      user[:model].update_attributes(user[:status])
    end
  end
  private

  def all_users_operators_empty?
    all_users_operators_empty = true
    @status[:users].each_value do |user|
      if user[:status][:operators].empty? == false
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

  puts "Result OPERATORS"
  pp operators

  radius.status = {
      room: {
          model: nil,
          status: {
              running: true,
              phase_env: {},
              variable_env: {},
              operators: [],
              stack: [],
              broadcast_id: 0
          }
      },
      users: {
          '1': {
              model: nil,
              status: {
                  stack: [],
                  operators: [],
                  active: true,
                  action_auth: "",
                  screen: ""
              }
          }
      }
  }
  radius.do_operators(operators, [], nil, nil)
  radius.status[:room][:status][:operators] = radius.status[:room][:status][:phase_env]['main'].clone
  puts

  radius.do_operators(radius.status[:room][:status][:operators], radius.status[:room][:status][:stack], nil, nil)

end