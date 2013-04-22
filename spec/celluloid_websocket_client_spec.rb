require 'rspec'
require 'celluloid/websocket/client'
require 'spec_helpers/handler_helper'

describe Celluloid::WebSocket::Client do
  context "with a reel webserver" do
    require 'spec_helpers/reel_webserver_helper'

    it "connects" do
      handler = HandlerHelper.new
      Celluloid::WebSocket::Client.new("ws://localhost:9123/spec", handler)
      sleep 5
    end
  end
end
