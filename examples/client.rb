require 'celluloid/websocket/client'

class MozWeb
  include Celluloid
  include Celluloid::Logger

  def initialize
    @client = Celluloid::WebSocket::Client.new("ws://localhost:1234/timeinfo", current_actor)
    @counter = 0
  end

  def on_open
    debug("websocket connection opened")
  end

  def on_message(data)
    @counter += 1
    info("message: #{data.inspect}")

    @client.close if @counter > 5
  end

  def on_close(code, reason)
    debug("websocket connection closed: #{code.inspect}, #{reason.inspect}")
  end
end

MozWeb.new

sleep
