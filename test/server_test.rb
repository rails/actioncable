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
    EM.run{
      ws = Faye::WebSocket::Client.new(websocket_url)

      ws.on(:message) do |message|
        app.broadcast 'chat', "Hello World"
        data = ActiveSupport::JSON.decode(message.data)
        unless data["identifier"] == "_ping"
          assert_equal "Hello World", data["message"]
          assert_equal "{\"channel\":\"ChatChannel\"}", data["identifier"]
          EM.stop_event_loop
        end
      end

      ws.on :open do |event|
        ws.send({command: 'subscribe', identifier: { channel: 'ChatChannel'}.to_json}.to_json)
      end
    }
  end

  test "subscribing to a channel with invalid params" do
  end
end
