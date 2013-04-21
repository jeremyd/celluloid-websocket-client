require 'websocket/protocol'
require 'celluloid'
require 'celluloid/io'

module Celluloid
  module IO
    class TCPSocket
      #include ConnectionMixin
      #include RequestMixin
      def url
        "http://localhost:9123/timeinfo"
      end
    end
  end
end

class MozWeb
  include Celluloid::IO
  include Celluloid::Logger

  def initialize
    @socket = Celluloid::IO::TCPSocket.new('0.0.0.0', '9123')
  end

  def start
    handler = WebSocket::Protocol.client(@socket)
    handler.onmessage { |message| info(message.data) }
    handler.onopen { |message| info("websocket opened") }
    handler.onclose { |message| info("websocket closed") }
    handler.start
    loop { handler.parse(@socket.readpartial(100)) }
  end
end

MozWeb.supervise_as(:mozweb)
Celluloid::Actor[:mozweb].start

sleep
