require 'celluloid/websocket/client'
require 'json'

class ReeltalkClient
  include Celluloid
  include Celluloid::Logger

  def initialize(url, user)
    @client = Celluloid::WebSocket::Client.new(url, current_actor)
    @user = user
  end

  def on_open
    @client.text JSON.dump(:action => "join", :user => @user)
    puts "Welcome to Reeltalk!"
  end

  def on_message(data)
    message = JSON.parse(data)
    case message["action"]
    when "control"
      reprompt do
        puts "~ #{message.fetch("user")} #{message.fetch("message")}"
      end
    when "message"
      user = message.fetch("user")
      return if user == @user
      reprompt do
        puts "#{user}: #{message.fetch("message")}"
      end
    else
      warn "unknown action: #{message.inspect}"
    end
  end

  def reprompt
    $stdout.write "\r"
    $stdout.write " " * 80
    $stdout.write "\r"
    yield if block_given?
    $stdout.write "#{@user}: "
  end

  def chat(message)
    @client.text JSON.dump(:action => "message", :message => message)
  end
end

url = 'ws://reeltalk.celluloid.io/chat'
#url = 'ws://localhost:1234/chat'
client = ReeltalkClient.new(url, ARGV.fetch(0) { abort "give me a user" })

loop do
  client.reprompt
  message = $stdin.gets.chomp
  client.chat(message)
end
