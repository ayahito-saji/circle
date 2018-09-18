class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def received(data)
    data = data['body']
    # データが届いたら
    UserChannel.push current_user, {order: 'echo', echo_id: data['echo_id']}

    # プレイ時
    current_room = current_user.room
    if current_room && current_room.interpreter_id
      interpreter = Interpreter.find_by(id: current_room.interpreter_id)
      if data['order'] == 'onload'
        interpreter.onload(current_user.id)
      elsif data['order'] == 'action'
        interpreter.action(current_user.id, data)
      end
    end
  end

  def UserChannel.push(user, json)
    DeliverScriptJob.perform_later(user, JSON.dump(json))
  end

  private
  def kill_thread(thread)
    if thread && thread.alive?
      thread.kill
    end
  end
end
