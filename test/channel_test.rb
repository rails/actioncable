require 'test_helper'

class ChannelTest < ActionCableTest

  class PingServer < ActionCable::Server::Base
  end

  def app
    PingServer
  end

  test "channel callbacks" do
    ws = Faye::WebSocket::Client.new(websocket_url)
  end
end