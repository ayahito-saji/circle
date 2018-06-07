class RoomController < ApplicationController
  def index
  end
  def create
    exit_room
    room = Room.create()
    current_user.update_attributes(room: room)
    redirect_to root_path
  end
  def search
    exit_room
    redirect_to root_path
  end

  private
  def exit_room
    if current.room && current_user.room.user.count == 1
      current_user.room.destroy
    end
    current_user.room = nil
  end
end
