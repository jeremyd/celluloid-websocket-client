module Celluloid
  module WebSocket
    module Client
      class Connection
        include Celluloid::IO
        include Celluloid::Logger

        def initialize(url)
          @url = url
          uri = URI.parse(url)
          port = uri.port || (uri.scheme == "ws" ? 80 : 443)
          @socket = Celluloid::IO::TCPSocket.new(uri.host, port)
          @handler = ::WebSocket::Protocol.client(self)

          async.run
        end
        attr_reader :url, :handler

        def run
          @handler.onopen do |event|
            info("websocket opened")
          end
          @handler.onmessage do |event|
            info(event.data)
          end
          @handler.onclose do |event|
            info("websocket closed")
          end

          @handler.start

          loop do
            @handler.parse(@socket.readpartial(1024))
          end
        end

        def write(buffer)
          @socket.write buffer
        end
      end
    end
  end
end


