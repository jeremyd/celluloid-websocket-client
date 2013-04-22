module Celluloid
  module WebSocket
    module Client
      class Connection
        include Celluloid::IO

        def initialize(url, handler)
          @url = url
          uri = URI.parse(url)
          port = uri.port || (uri.scheme == "ws" ? 80 : 443)
          @socket = Celluloid::IO::TCPSocket.new(uri.host, port)
          @client = ::WebSocket::Protocol.client(self)
          @handler = handler

          async.run
        end
        attr_reader :url

        def run
          @client.onopen do |event|
            @handler.on_open if @handler.respond_to?(:on_open)
          end
          @client.onmessage do |event|
            @handler.on_message(event.data) if @handler.respond_to?(:on_message)
          end
          @client.onclose do |event|
            @handler.on_close(event.code, event.reason) if @handler.respond_to?(:on_close)
          end

          @client.start

          loop do
            @client.parse(@socket.readpartial(1024))
          end
        end

        def write(buffer)
          @socket.write buffer
        end
      end
    end
  end
end


