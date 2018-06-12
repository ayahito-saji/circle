class RoomsController < ApplicationController
  def show
    unless user_signed_in? && @current_room = current_user.room
      redirect_to current_user_path
    end
  end
  def create
    exit_room
    room = Room.new(params.require(:rooms).permit(:name, :password))
    if room.save
      current_user.update_attributes(room: room)
      redirect_to current_room_path, notice: 'Created rooms successfully.'
    else
      redirect_to current_user_path, notice: 'Invalid name or password.'
    end
  end
  def search
    exit_room
    room = Room.find_by(name: params[:rooms][:name])
    if room && room.password == params[:rooms][:password]
      current_user.update_attributes(room: room)
      room.users.each do |member|
        UserChannel.broadcast_to(member, "update_member_list(#{room.users.map{|item| item.name}})")
      end
      redirect_to current_room_path, notice: 'Entered successfully.'
    else
      redirect_to current_user_path, notice: 'Invalid name or password.'
    end
  end
  def destroy
    exit_room
    redirect_to current_user_path, notice: 'Exited successfully.'
  end

  private
  def exit_room
    current_room = current_user.room
    current_user.update_attributes(room: nil)
    if current_room
      if current_room.users.count == 0
        current_room.destroy
      else
        current_room.users.each do |member|
          UserChannel.broadcast_to(member, "update_member_list(#{current_room.users.map{|item| item.name}})")
        end
      end
    end
  end
end