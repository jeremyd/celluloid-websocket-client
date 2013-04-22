module Celluloid
  module WebSocket
    module Client
      class Connection
        def initialize(socket, url)
          @socket = socket
          @url = url
        end
        attr_reader :url

        def write(buffer)
          @socket.write buffer
        end
      end
    end
  end
end


