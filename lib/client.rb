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
    s = Celluloid::IO::TCPSocket.new('0.0.0.0', '9123')
    handler = WebSocket::Protocol.client(s)
    handler.onmessage { |message| info(message.data) }
    handler.onopen { |message| info("websocket opened") }
    handler.onclose { |message| info("websocket closed") }
    handler.start
    loop { handler.parse(s.readpartial(100)) }
  end
end

MozWeb.supervise_as(:mozweb)

sleep
