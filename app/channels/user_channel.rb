class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    kill_thread @main_thread
    kill_thread @tle_thread
  end

  def received(data)
    # データが届いたら
    UserChannel.push current_user, {order: 'echo', echo_id: data['body']['echo_id']}

    # ルールブック編集時
    if data['body']['order'] == 'run_in_editor'
      kill_thread @main_thread
      kill_thread @tle_thread
      @main_thread = Thread.start do
        begin
          radius = Radius::Radius.new
          task_code = radius.compile(data['body']['code'])
          env = radius.process(task_code)
          UserChannel.push current_user, {order: 'finished_in_editor', env: env}
          kill_thread @tle_thread
        rescue => e
          UserChannel.push current_user, {order: 'error', error: e}
          kill_thread @tle_thread
        end
      end
      @tle_thread = Thread.start do
        sleep 1
        kill_thread @main_thread
        UserChannel.push current_user, {order: 'exceeded_time_in_editor'}
      end
      return
    elsif data['body']['order'] == 'stop_in_editor'
      kill_thread @main_thread
      kill_thread @tle_thread
      UserChannel.push current_user, {order: 'stopped_in_editor'}
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
