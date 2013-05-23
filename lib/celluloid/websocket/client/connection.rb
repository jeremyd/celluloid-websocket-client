require 'forwardable'

module Celluloid
  module WebSocket
    module Client
      class Connection
        include Celluloid::IO
        extend Forwardable

        def initialize(url, handler)
          @url = url
          uri = URI.parse(url)
          port = uri.port || (uri.scheme == "ws" ? 80 : 443)
          @socket = Celluloid::IO::TCPSocket.new(uri.host, port)
          @client = ::WebSocket::Driver.client(self)
          @handler = handler

          async.run
        end
        attr_reader :url

        def run
          @client.on('open') do |event|
            @handler.async.on_open if @handler.respond_to?(:on_open)
          end
          @client.on('message') do |event|
            @handler.async.on_message(event.data) if @handler.respond_to?(:on_message)
          end
          @client.on('close') do |event|
            @handler.async.on_close(event.code, event.reason) if @handler.respond_to?(:on_close)
          end

          @client.start

          loop do
            @client.parse(@socket.readpartial(1024))
          end
        end

        def_delegators :@client, :text, :binary, :ping, :close, :protocol

        def write(buffer)
          @socket.write buffer
        end
      end
    end
  end
end


