require 'celluloid/websocket/client'

class MozWeb
  include Celluloid::IO
  include Celluloid::Logger

  def initialize
    @socket = Celluloid::IO::TCPSocket.new('127.0.0.1', '1234')
    connection = Celluloid::WebSocket::Client::Connection.new(@socket, "http://localhost:1234/timeinfo")
    @handler = ::WebSocket::Protocol.client(connection)
  end

  def start
    @handler.onmessage { |message| info(message.data) }
    @handler.onopen { |message| info("websocket opened") }
    @handler.onclose { |message| info("websocket closed") }
    @handler.start
    loop { @handler.parse(@socket.readpartial(100)) }
  end
end

MozWeb.supervise_as(:mozweb)
Celluloid::Actor[:mozweb].start

sleep
