class AddRoomToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :room, foreign_key: true
  end
end
