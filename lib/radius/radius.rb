class Radius::Radius
  def run(current_user, pushed_data)
    puts "pushed_data: #{pushed_data}"
  end
  def compile(code)
    parser = Radius::RadiusParser.new
    tree = parser.parse(code)

    pp tree

    # コードを再帰的に評価してtask_codeを生成する
    @task_code = evaluate(tree)

    pp @task_code

    return nil
  end

  private
  def evaluate(tree)

    operator = tree[0]  # 命令種類を規定
    line = tree[1]      # 命令の行番号
    value = tree[2]     # 値
    child_trees = tree[3]  # 梢

    case operator
      when :phases
        # フェイズごとに評価する(フェイズをまたぐgoto文が不完全)
        evaluated_phases = []
        child_trees.each do |child_tree|
          evaluated_phases << evaluate(child_tree)
        end
      when :phase

    end
  end
end
