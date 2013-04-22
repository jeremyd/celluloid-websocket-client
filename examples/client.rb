require 'celluloid/websocket/client'
require 'pry'

Celluloid::WebSocket::Client.new("ws://localhost:1234/timeinfo")

sleep
