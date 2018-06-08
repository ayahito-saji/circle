class CreateRulebooks < ActiveRecord::Migration[5.1]
  def change
    create_table :rulebooks do |t|
      t.string :title, null: false, default: ""
      t.text :description, default: ""
      t.text :code, default: ""
      t.references :user, foreign_key: true
      t.integer :permission, default: 0

      t.timestamps
    end
  end
end
