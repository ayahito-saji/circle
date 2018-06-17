class NStackRadius
  require_relative 'n_stack_radius_parser'
  def analysis(rulebook)
    parser = NStackRadiusParser.new
    parser.parse(rulebook)
  end
  def do_operators(operators, stack, user, pushed_data)
    while operators.length > 0
      operator = operators.pop
      puts "OPERATOR #{operator}"
      arguments = stack.pop(operator[2]) # オペレータで使用する変数
      data = operator[1]                         # オペレータで使用する定数
      puts "ARGUMENTS #{arguments}"
      puts "CONSTANT #{data}"
      puts "USER #{user[:model].name}" if user

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
              broadcast_to user, "$('#screen').html(\"#{user[:status][:screen]}\")"
              stack.push([:null, nil, 0])
            when "button"
              user[:status][:screen] += "<button onclick=Input.click_button(this)>#{arguments[1][1][0][1]}</button><br/>"
              broadcast_to user, "$('#screen').html(\"#{user[:status][:screen]}\")"
              stack.push([:null, nil, 0])
            when "input"
              operators.push([:inputted, nil, 0])
              return
          end

        when :inputted
          if pushed_data == nil || pushed_data['value'] == nil
            operators.push(operator)
            return
          end
          stack.push([:string, pushed_data['value'], 0])

        when :assign_variable
          @status[:room][:status][:variable_env][arguments[0][1]] = arguments[1]
          pp @status[:room][:status][:variable_env]
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
        user[:status][:action_auth] = ""
        broadcast_to user, "$('#screen').html(\"#{user[:status][:screen]}\")"
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
      @status[:room][:status][:running] = false
      @status[:users].each_value do |user|
        broadcast_to user, "alert('停止: ルールブックは停止されました');"
      end
      return
    end
    p "MAIN LOOP"
    puts "@status = #{@status}"
    while true
      # メインフェイズの実行
      if all_users_operators_empty?
        do_operators(@status[:room][:status][:operators], @status[:room][:status][:stack], nil, nil)
      end
      # ユーザーフェイズの実行
      @status[:users].each_value do |user|
        puts "USER PHASE: #{user[:model][:name]}"
        do_operators(user[:status][:operators], user[:status][:stack], user, nil)
      end
      break if @status[:room][:status][:operators].empty?
      break if !all_users_operators_empty?
    end
  end

  # 各デバイスのフロントで実行されるプログラムを渡します。

  def broadcast_to(user, value)
    @status[:room][:status][:broadcast_id] += 1
    DeliverScriptJob.perform_later(user[:model], value, @status[:room][:status][:broadcast_id])

    # debug_code = "<h3>Operators</h3>"
    # debug_code += "<table><tr>"
    # debug_code += "<th>Room</th>"
    # @status[:users].each_value { |user| debug_code += "<th>#{user[:model].name}</th>"}
    # debug_code += "</tr><tr>"
    # debug_code += "<td>"
    # @status[:room][:status][:operators].each { |operator| debug_code += "#{operator}<br/>"}
    # debug_code += "</td>"
    # @status[:users].each_value do |user|
    #   debug_code += "<td>"
    #   user[:status][:operators].each { |operator| debug_code += "#{operator}<br/>"}
    #   debug_code += "</td>"
    # end
    # debug_code += "</tr></table>"
    # @status[:users].each_value do |user|
    #   UserChannel.broadcast_to user[:model], "$('#debug').html('#{debug_code}')"
    # end
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
  radius.do_operators(operators, [], nil, nil)
  radius.do_operators(radius.phase_environment['main'].clone, [], nil, nil)
end