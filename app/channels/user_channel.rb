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
    if data['body']['order'] == 'run' # 開始
      # ルームデータ取得
      radius.room = current_user.room
      # 構文解析
      operators = radius.analysis(Rulebook.find_by(id: data['body']['rulebook']).code)
      # フェイズ取得
      radius.do_operators(operators, [], nil)
      # メインフェイズの実行
      result = radius.do_operators(radius.phase_environment['main'].clone, [], nil)
      # 結果の保存
      radius.room.update_attributes(result)
    end
#    UserChannel.broadcast_to(current_user, "alert('#{data['body']}');")
  end
end
