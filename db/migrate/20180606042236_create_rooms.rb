class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name,           null: false, default: ""
      t.string :password,       null: true, default: ""
      t.integer :rulebook_id,   null: true
      t.text :program_counter,  null: true
      t.text :stack,            null: true
      t.boolean :running ,      null: false, default: false
      t.integer :broadcast_id,  null: true

      t.timestamps
    end
    add_index :rooms, :name, unique: true
  end
end
