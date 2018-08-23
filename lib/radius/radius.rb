class Radius::Radius
  def run(current_user, pushed_data)
    puts "pushed_data: #{pushed_data}"
  end
  def compile(code)
    parser = Radius::RadiusParser.new
    tree = parser.parse(code)

    pp tree

    # コードを再帰的に評価してtask_codeを生成する
    task_code = evaluate(tree)

    # pp task_code

    return task_code
  end
  def process(task_code)
    stack = []
    env = {}
    program_counter = 0

    while true
      task = task_code[program_counter]
      break unless task
      puts "* #{task}"
      z = run_task(task, stack, env)
      stack.push(z) if z
      break if z == :end
      puts "#{stack}"
      puts
      program_counter += 1
    end

    puts "-- Process finished --"
    return env
  end

  private
  def evaluate(tree)

    operator = tree[0]      # 命令種類を規定
    line = tree[1]          # 命令の行番号
    value = tree[2]         # 値
    child_trees = tree[3]   # 梢

    case operator
      when :phases # フェイズデータのハッシュから，リンクしてtask_codeを返す
        # フェイズごとに評価する(フェイズをまたぐgoto文が不完全)
        evaluated_phases = []
        child_trees.each do |child_tree|
          evaluated_phases << evaluate(child_tree)
        end
        pp evaluated_phases

        task_code = []
        evaluated_phases.each do |evaluated_phase|
          task_code += evaluated_phase[1]
        end
        return task_code

      when :phase # task_codeではなく，フェイズデータのハッシュを返す
        phase_data = [
          evaluate(child_trees[0]), # フェイズの識別子
          evaluate(child_trees[1]) << [:end, nil, nil, 0]  # フェイズのtask_code
        ]
        return phase_data

      when :block
        task_code = []
        task_code << [:_block, line, value, 0]
        child_trees.each do |child_tree|
          task_code += evaluate(child_tree)
        end
        task_code << [:block, line, value, child_trees.length]
        return task_code

      # リテラル
      when :number
        task_code = []
        task_code << [:number, line, value, 0]
        return task_code
      when :string
        task_code = []
        task_code << [:string, line, value, 0]
        return task_code
      when :identifier
        task_code = []
        task_code << [:identifier, line, value, 0]
        return task_code
      when :boolean
        task_code = []
        task_code << [:boolean, line, value, 0]
        return task_code

      # 四則演算
      when :add
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:add, line, value, 2]
        return task_code
      when :dif
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:dif, line, value, 2]
        return task_code
      when :mul
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:mul, line, value, 2]
        return task_code
      when :div
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:div, line, value, 2]
        return task_code
      when :mod
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:mod, line, value, 2]
        return task_code

      # 等式・不等式
      when :eq
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:eq, line, value, 2]
        return task_code
      when :neq
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:neq, line, value, 2]
        return task_code
      when :lt
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:lt, line, value, 2]
        return task_code
      when :lte
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:lte, line, value, 2]
        return task_code
      when :gt
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:gt, line, value, 2]
        return task_code
      when :gte
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:gte, line, value, 2]
        return task_code

      # 変数参照，代入
      when :ref_var
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code << [:ref_var, line, value, 1]
        return task_code
      when :ref_index
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:ref_index, line, value, 2]
        return task_code
      when :ref_key
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:ref_key, line, value, 2]
        return task_code

      when :asg_var
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code << [:asg_var, line, value, 2]
      when :asg_index
        task_code = []
        task_code += evaluate(child_trees[0])
        task_code += evaluate(child_trees[1])
        task_code += evaluate(child_trees[2])
        task_code << [:asg_index, line, value, 3]

      when :new_array
        task_code = []
        child_trees.each do |child_tree|
          task_code += evaluate(child_tree)
        end
        task_code << [:new_array, line, value, child_trees.length]

      when :new_hash
        task_code = []
        child_trees.each do |child_tree|
          task_code += evaluate(child_tree)
        end
        task_code << [:new_hash, line, value, child_trees.length]

    end
  end
  def run_task(task, stack, env)
    operator = task[0]
    line = task[1]
    value = task[2]
    child_codes = stack.pop(task[3])
    p child_codes
    case operator
      when :_block
        return nil
      when :block
        return child_codes[-1]
      when :end
        return :end
      # リテラル
      when :number
        return task
      when :string
        return task
      when :identifier
        return task
      when :boolean
        return task
      when :array
        return task
      when :hash
        return task

      # 四則演算
      when :add
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:number, nil, child_codes[0][2] + child_codes[1][2], 0]
        elsif child_codes[0][0] == :number && child_codes[1][0] == :string
          return [:string, nil, child_codes[0][2].to_s + child_codes[1][2], 0]
        elsif child_codes[0][0] == :string && child_codes[1][0] == :number
          return [:string, nil, child_codes[0][2] + child_codes[1][2], 0].to_s
        elsif child_codes[0][0] == :string && child_codes[1][0] == :string
          return [:string, nil, child_codes[0][2] + child_codes[1][2], 0]
        else
          raise "演算エラー: 演算できません. '+' (#{line}行目)"
        end
      when :dif
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:number, nil, child_codes[0][2] - child_codes[1][2], 0]
        else
          raise "演算エラー: 演算できません. '-' (#{line}行目)"
        end
      when :mul
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:number, nil, child_codes[0][2] * child_codes[1][2], 0]
        elsif child_codes[0][0] == :string && child_codes[1][0] == :number
          return [:number, nil, child_codes[0][2] * child_codes[1][2], 0]
        else
          raise "演算エラー: 演算できません. '*' (#{line}行目)"
        end
      when :div
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          if child_codes[1][2] != 0
            return [:number, nil, child_codes[0][2] / child_codes[1][2].to_f, 0]
          else
            raise "演算エラー: 0で除算できません. '/' (#{line}行目)"
          end
        else
          raise "演算エラー: 演算できません. '/' (#{line}行目)"
        end
      when :mod
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          if child_codes[1][2] != 0
            return [:number, nil, child_codes[0][2] % child_codes[1][2], 0]
          else
            raise "演算エラー: 0で除算できません. '%' (#{line}行目)"
          end
        else
          raise "演算エラー: 演算できません. '%' (#{line}行目)"
        end
      # 等式・不等式
      when :eq
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:boolean, nil, child_codes[0][2] == child_codes[1][2], 0]
        elsif child_codes[0][0] == :string && child_codes[1][0] == :string
          return [:boolean, nil, child_codes[0][2] == child_codes[1][2], 0]
        elsif child_codes[0][0] == :boolean && child_codes[1][0] == :boolean
          return [:boolean, nil, child_codes[0][2] == child_codes[1][2], 0]
        else
          raise "比較エラー: 比較できません. '==' (#{line}行目)"
        end
      when :neq
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:boolean, nil, child_codes[0][2] != child_codes[1][2], 0]
        elsif child_codes[0][0] == :string && child_codes[1][0] == :string
          return [:boolean, nil, child_codes[0][2] != child_codes[1][2], 0]
        elsif child_codes[0][0] == :boolean && child_codes[1][0] == :boolean
          return [:boolean, nil, child_codes[0][2] != child_codes[1][2], 0]
        else
          raise "比較エラー: 比較できません. '!=' (#{line}行目)"
        end
      when :lt
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:boolean, nil, child_codes[0][2] < child_codes[1][2], 0]
        else
          raise "比較エラー: 比較できません. '<' (#{line}行目)"
        end
      when :lte
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:boolean, nil, child_codes[0][2] <= child_codes[1][2], 0]
        else
          raise "比較エラー: 比較できません. '<=' (#{line}行目)"
        end
      when :gt
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:boolean, nil, child_codes[0][2] > child_codes[1][2], 0]
        else
          raise "比較エラー: 比較できません. '>' (#{line}行目)"
        end
      when :gte
        if child_codes[0][0] == :number && child_codes[1][0] == :number
          return [:boolean, nil, child_codes[0][2] >= child_codes[1][2], 0]
        else
          raise "比較エラー: 比較できません. '>=' (#{line}行目)"
        end

      # 変数参照，代入
      when :ref_var
        if child_codes[0][0] == :identifier && env[child_codes[0][2]]
          return env[child_codes[0][2]]
        else
          raise "未定義エラー: 変数が定義されていません. '#{child_codes[0][2]}' (#{line}行目)"
        end
      when :ref_index
        if child_codes[0][0] == :array
          if child_codes[1][0] == :number
            if child_codes[0][2][child_codes[1][2]]
              return child_codes[0][2][child_codes[1][2]]
            else
              return [:null, nil, nil, 0]
            end
          else
            raise "配列参照エラー: 整数でのみ参照可能です. '#{child_codes[1][2]}' (#{line}行目)"
          end
        elsif child_codes[0][0] == :hash
          if child_codes[1][0] == :string || child_codes[1][0] == :identifier
            if child_codes[0][2][child_codes[1][2]]
              return child_codes[0][2][child_codes[1][2]]
            else
              return [:null, nil, nil, 0]
            end
          else
            raise "ハッシュ参照エラー: 文字列でのみ参照可能です. '#{child_codes[1][2]}' (#{line}行目)"
          end
        else
          raise "参照エラー: 配列またはハッシュではありません. (#{line}行目)"
        end

      when :asg_var
        if child_codes[1][0] == :identifier
          env[child_codes[1][2]] = child_codes[0]
          return child_codes[0]
        else
          raise "代入エラー: 変数が定義できません. '#{child_codes[1][2]}' (#{line}行目)"
        end
      when :asg_index


      # 配列，ハッシュ生成
      when :new_array
        return [:array, line, child_codes, 0]

      when :new_hash
        hash = {}
        (child_codes.length / 2).times do |i|
          if child_codes[i*2][0] == :string
            hash[child_codes[i*2][2]] = child_codes[i*2 + 1]
          else
            raise "ハッシュエラー: キーの値が文字列ではありません '#{child_codes[i*2][2]}' (#{line}行目)"
          end
        end
        return [:hash, line, hash, 0]

    end
  end
end
