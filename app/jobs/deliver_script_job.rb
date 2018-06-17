class DeliverScriptJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    UserChannel.broadcast_to(args[0], {value: args[1], broadcast_id: args[2]})
  end
end
