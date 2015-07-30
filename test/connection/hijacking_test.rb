require 'test_helper'
require 'stubs/test_server'

class ActionCable::Connection::HijackingTest < ActiveSupport::TestCase
  class Connection < ActionCable::Connection::Base
    attr_reader :websocket, :message_buffer, :connected
    protect_from_hijacking

    after_connect do
      @connected = true
    end
  end

  test "with invalid token" do
    server = TestServer.new
    env = Rack::MockRequest.env_for "/?token=#{'X'*32}", 'HTTP_CONNECTION' => 'upgrade', 'HTTP_UPGRADE' => 'websocket'
    connection = Connection.new(server, env)
    connection.websocket.expects(:close)
    connection.process
    connection.send :on_open
  end

  test "with valid token" do
    token = SecureRandom.base64(32)
    server = TestServer.new
    env = Rack::MockRequest.env_for "/?token=#{URI.encode_www_form_component(token)}", 'HTTP_CONNECTION' => 'upgrade', 'HTTP_UPGRADE' => 'websocket'
    connection = Connection.new(server, env)
    connection.send(:session)["_csrf_token"] = token
    EventMachine.expects(:add_periodic_timer)
    connection.websocket.expects(:transmit).with(regexp_matches(/\_ping/))
    connection.message_buffer.expects(:process!)
    connection.process
    connection.send :on_open
    assert connection.connected
  end
end
