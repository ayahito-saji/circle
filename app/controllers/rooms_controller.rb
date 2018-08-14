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
      current_user.update_attributes(room: room, member_id: 0)
      redirect_to current_room_path, notice: 'Created rooms successfully.'
    else
      redirect_to current_user_path, notice: 'Invalid name or password or the name is already taken.'
    end
  end
  def search
    exit_room
    room = Room.find_by(name: params[:rooms][:name])
    if room && room.password == params[:rooms][:password] && room.running == false
      current_user.update_attributes(room: room, member_id: room.users.count)
      room.users.each do |member|
        UserChannel.push member, {
            order: 'member_changed',
            members: room.users.order(:member_id).map {|item| "#{item.name}"}
        }
      end
      redirect_to current_room_path, notice: 'Entered successfully.'
    else
      redirect_to current_user_path, notice: 'Invalid name or password or room is running rulebook.'
    end
  end
  def play
    unless user_signed_in? && @current_room = current_user.room
      redirect_to current_user_path
    end
    unless @current_room.running?
      redirect_to current_room_path
    end
  end
  def destroy
    if exit_room
      redirect_to current_user_path, notice: 'Exited successfully.'
    else
      redirect_to current_room_path, alert: 'Rulebook is running.'
    end
  end

  private
  def exit_room
    current_room = current_user.room
    if current_room
      if current_room.running? == false
        current_user.update_attributes(room: nil)
        if current_room.users.count == 0
          current_room.destroy
        else
          current_room.users.order(:member_id).each_with_index do |member, index|
            member.update_attributes(member_id: index)
            UserChannel.push member, {
                order: 'member_changed',
                members: current_room.users.order(:member_id).map {|item| "#{item.name}"}
            }
          end
        end
      else
        return false
      end
    else
      current_user.update_attributes(room: nil)
    end
    return true
  end
end
