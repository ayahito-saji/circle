class UserChannel < ApplicationCable::Channel
  require_relative '../../lib/assets/n_stack_radius'
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def push(data)
    if current_user.room
      radius = NStackRadius.new
      radius.setStatus(current_user.room)
      radius.run(current_user, data['body'])
      radius.saveStatus
    end
  end
end
