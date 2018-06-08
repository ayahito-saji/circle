class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name,           null: false, default: ""
      t.string :password,       null: true, default: ""
      t.text :phase_env,        null: true
      t.text :variable_env,     null: true
      t.text :stack,            null: true
      t.text :operators,        null: true

      t.timestamps
    end
    add_index :rooms, :name, unique: true
  end
end
