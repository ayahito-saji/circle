class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def push(data)
    UserChannel.broadcast_to(current_user, "alert('#{data['body']}');")
  end
end
