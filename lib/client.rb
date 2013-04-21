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

    handler.onmessage { |message| puts "never gets here" }
    handler.onopen { |message| puts "open" }
    handler.onclose { |message| puts "close" }

    handler.start
  end
end

MozWeb.supervise_as(:mozweb)

sleep
