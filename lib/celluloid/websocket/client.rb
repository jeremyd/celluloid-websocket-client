require 'websocket/protocol'
require 'celluloid'
require 'celluloid/io'

module Celluloid
  module WebSocket
    module Client
      def self.new(url)
        Connection.new(url)
      end
    end
  end
end

require 'celluloid/websocket/client/connection'
