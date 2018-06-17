class AddBroadcastIdToRoom < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :broadcast_id, :integer, null: false, default: 0
  end
end
