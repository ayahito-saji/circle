class PlaysController < ApplicationController
  def create
    redirect_to current_room_path, alert: 'Rulebook is already running' and return if current_user.room.running?
    rulebook = Rulebook.find_by(id: params[:id])
    redirect_to current_room_path, alert: 'Rulebook is not exist' and return unless rulebook

    interpreter = Interpreter.create!(rulebook_id: rulebook.id)
    current_user.room.update_attributes(
        {
            interpreter_id: interpreter.id
        }
    )

    current_user.room.users.each do |member|
      UserChannel.push member, {
          order: 'play_started',
          name: rulebook.title
      }
    end
    redirect_to current_play_path
  end
  def destroy
    redirect_to current_room_path and return unless current_user.room.running?

    Interpreter.find_by(id: current_user.room.interpreter_id).destroy
    current_user.room.update_attributes(
        {
            interpreter_id: nil
        }
    )

    current_user.room.users.each do |member|
      UserChannel.push member, {
          order: 'play_ended'
      }
    end

    redirect_to current_room_path
  end
  def show
    unless user_signed_in? && current_user.room && current_user.room.running?
      redirect_to current_user_path
    end
  end
end
