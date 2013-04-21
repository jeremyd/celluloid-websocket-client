require 'reel'

class TimeClient
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  def initialize(websocket)
    info "Streaming changes to client"
    @socket = websocket
    subscribe('time_change', :notify_time_change)
    every(1) { publish 'time_change', "asdfasdfasdfasdfhi" }
  end

  def notify_time_change(topic, new_time)
    @socket << new_time
  rescue Reel::SocketError
    info "Time client disconnected"
    terminate
  end
end

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
    if socket.url == "/timeinfo"
      TimeClient.new(socket)
    else
      info "Received invalid WebSocket request for: #{socket.url}"
      socket.close
    end
  end
end

WebServer.supervise_as(:webserver)

sleep
