class UserChannel < ApplicationCable::Channel
  require_relative '../../lib/assets/n_stack_radius'
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def push(data)
    radius = NStackRadius.new
    radius.room = current_user.room
    if data['body']['order'] == 'run' # 開始
      #画面の初期化
      radius.room.users.each do |user|
        UserChannel.broadcast_to(user, "$('#screen').html('')")
      end

      # 構文解析
      operators = radius.analysis(Rulebook.find_by(id: data['body']['rulebook']).code)
      # フェイズ取得
      result = radius.do_operators(operators, [], nil)
      result[:operators] = radius.phase_environment['main'].clone
      radius.room.update_attributes(result)
      UserChannel.broadcast_to(current_user, "alert('mainフェイズが見つかりません.');") if radius.phase_environment['main'].nil?
    end

    # メインフェイズの実行
    result = radius.do_operators(radius.room.operators, [], nil)
    UserChannel.broadcast_to(current_user, result)
    # 結果の保存
    radius.room.update_attributes(result)
#    UserChannel.broadcast_to(current_user, "alert('#{data['body']}');")
  end
end
