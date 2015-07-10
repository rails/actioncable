require 'test_helper'

class ServerTest < ActionCableTest
  class ChatServer < ActionCable::Server::Base
  end

  def app
    ChatServer.new
  end

  test "channel registration" do
    assert_equal app.channel_classes, [ ChatChannel ]
  end

  test "subscribing to a channel with valid params" do
    ws = Faye::WebSocket::Client.new(websocket_url)

    ws.on(:message) do |message|
      puts message.inspect
    end

    ws.send command: 'subscribe', identifier: { channel: 'chat'}.to_json
  end

  test "subscribing to a channel with invalid params" do
  end
end
