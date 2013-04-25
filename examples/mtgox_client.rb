require 'celluloid/websocket/client'

class MtGoxClient
  include Celluloid
  include Celluloid::Logger

  def initialize
    @client = Celluloid::WebSocket::Client.new("ws://websocket.mtgox.com/mtgox?Channel=trades", current_actor, :headers => { "Origin" => "ws://websocket.mtgox.com:80" })
    @counter = 0
  end

  def on_open
    debug("websocket connection opened")
  end

  def on_message(data)
    info("message: #{data.inspect}")
  end

  def on_close(code, reason)
    debug("websocket connection closed: #{code.inspect}, #{reason.inspect}")
  end
end

MtGoxClient.new

sleep
