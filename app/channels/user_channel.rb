class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    kill_thread @thread
  end

  def received(data)
    # データが届いたら、
    UserChannel.push current_user, {order: 'echo', echo_id: data['body']['echo_id']}

    # ルールブック編集時
    if data['body']['order'] == 'run_in_editor'
      kill_thread @thread
      @thread = Thread.start do
        radius = Radius::Radius.new
        task_code = radius.compile(data['body']['code'])
        begin
          env = radius.process(task_code)
          UserChannel.push current_user, {order: 'result_in_editor', env: env}
        rescue => e
          UserChannel.push current_user, {order: 'error', error: e}
        end
      end
      return
    elsif data['body']['order'] == 'stop_in_editor'
      kill_thread @thread
      UserChannel.push current_user, {order: 'stopped_code'}
      return
    end

    # プレイ時
    if current_user.room
      radius = Radius::Radius.new
      radius.run(current_user, data['body'])
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
