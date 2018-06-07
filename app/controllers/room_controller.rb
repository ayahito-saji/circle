class RoomController < ApplicationController
  def create
    exit_room
    room = Room.new(params.require(:room).permit(:name, :password))
    if room.save
      current_user.update_attributes(room: room)
      redirect_to root_path, notice: 'Created room successfully.'
    else
      redirect_to root_path, notice: 'Invalid name or password.'
    end
  end
  def search
    exit_room
    room = Room.find_by(name: params[:room][:name])
    if room && room.password == params[:room][:password]
      current_user.update_attributes(room: room)
      redirect_to root_path, notice: 'Entered successfully.'
    else
      redirect_to root_path, notice: 'Invalid name or password.'
    end
  end
  def destroy
    exit_room
    redirect_to root_path, notice: 'Exited successfully.'
  end

  private
  def exit_room
    if current_user.room && current_user.room.users.count == 1
      current_user.room.destroy
    end
    current_user.update_attributes(room: nil)
  end
end
