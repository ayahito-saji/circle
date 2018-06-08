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
      puts "オペレータ #{operator}"
      arguments = stack.pop(operator[2]) # オペレータで使用する変数
      data = operator[1]                         # オペレータで使用する定数
      puts "引数 #{arguments}"
      puts "定数 #{data}"

      case operator[0] # オペレータ種類
        when :identifier
          stack.push(operator)
        when :number
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
        when :assign_variable
          @variable_environment[arguments[0][1]] = arguments[1]
          stack.push(arguments[1])
        when :reference_variable
          stack.push(@variable_environment[arguments[0][1]])
        when :goto
          operators << @phase_environment[arguments[0][1]].clone
        when :phase
          # puts "フェイズ名:#{arguments[0][1][0]} フェイズ内容:#{data[0]}"
          @phase_environment[arguments[0][1]] = data
          stack.push([:null, nil, 0])
        else
          stack.push([:null, nil, 0])
      end
      puts "スタック #{stack}"
      puts ""
    end
    stack.pop()
    puts "フェイズデータ"
    pp @phase_environment
    puts "変数環境"
    pp @variable_environment
    return {
        phase_env: @phase_environment,
        variable_env: @variable_environment,
        stack: stack,
        operators: operators
    }
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
end