class HandlerHelper
  include Celluloid
  include Celluloid::Logger

  def initialize
    Celluloid::WebSocket::Client.new("ws://localhost:1234/timeinfo", current_actor)
  end

  def on_message(data)
    info("message: #{data.inspect}")
  end
end

