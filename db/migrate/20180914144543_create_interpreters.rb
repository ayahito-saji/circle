class CreateInterpreters < ActiveRecord::Migration[5.1]
  def change
    create_table :interpreters do |t|
      t.integer :rulebook_id
      t.text :task_code
      t.text :env
      t.text :sys_env
      t.string :processor_id

      t.timestamps
    end
  end
end
