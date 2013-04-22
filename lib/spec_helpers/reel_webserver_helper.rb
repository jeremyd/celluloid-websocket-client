require 'reel'

class WebServer < Reel::Server
  include Celluloid::Logger
  def initialize(host = "0.0.0.0", port = 9123)
    super(host, port, &method(:on_connection))
  end

  def on_connection(connection)
    while request = connection.request
      case request
      when Reel::Request
        info "Received a *normal request"
      when Reel::WebSocket
        info "Received a WebSocket connection"
        route_websocket request
      end
    end
  end

  def route_websocket(socket)
    if socket.url == "/spec"
      every(1) { socket << "hiwebsocket" }
    else
      info "Received invalid WebSocket request for: #{socket.url}"
      socket.close
    end
  end
end

WebServer.supervise_as(:webserver)
