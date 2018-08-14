class DeliverScriptJob < ApplicationJob
  queue_as :default

  def perform(user, json)
    # Do something later
    UserChannel.broadcast_to(user, json)
  end
end
