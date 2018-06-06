class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name,           null: false, default: ""
      t.string :password,       null: true, default: ""

      t.timestamps
    end
    add_index :rooms, :name, unique: true
  end
end
