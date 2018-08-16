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
        return evaluated_phases[0][1]

      when :phase # task_codeではなく，フェイズデータのハッシュを返す
        phase_data = [
          evaluate(child_trees[0]), # フェイズの識別子
          evaluate(child_trees[1])  # フェイズのtask_code
        ]
        return phase_data

      when :block
        task_code = []
        task_code << [:_block, line, value, nil]
        child_trees.each do |child_tree|
          task_code += evaluate(child_tree)
        end
        task_code << [:block, line, value, child_trees.length]
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
    end
  end
end
