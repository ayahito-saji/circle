class DeliverScriptJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    UserChannel.broadcast_to(args[0], args[1])
  end
end
