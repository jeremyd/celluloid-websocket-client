require 'rspec'
require 'celluloid/websocket/client'
require 'celluloid/websocket/client/spec_helpers/handler_helper'

describe Celluloid::WebSocket::Client do
  context "with a reel webserver" do
    require 'celluloid/websocket/client/spec_helpers/reel_webserver_helper'

    it "connects" do
      handler = HandlerHelper.new
      sleep 5
    end
  end
end
