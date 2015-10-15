require 'test_helper'
require 'stubs/test_server'
require 'stubs/user'

class ActionCable::Connection::IdentifierTest < ActionCable::TestCase
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    attr_reader :websocket
    attr_writer :pubsub

    public :process_internal_message

    def connect
      self.current_user = User.new "lifo"
    end
  end

  setup do
    @server = TestServer.new

    @env = Rack::MockRequest.env_for "/test", 'HTTP_CONNECTION' => 'upgrade', 'HTTP_UPGRADE' => 'websocket'
    @connection = Connection.new(@server, @env)
  end

  test "connection identifier" do
    open_connection
    assert_equal "User#lifo", @connection.connection_identifier
  end

  test "should subscribe to internal channel on open" do
    run_in_eventmachine do
      @connection.pubsub = mock('pubsub')

      open_connection

      # Use next tick to give eventmachine the chance to run pubsub.subscribe
      EM.next_tick { @connection.pubsub.expects(:subscribe).with('action_cable/User#lifo') }
    end
  end

  test "should unsubscribe from internal channel on close" do
    run_in_eventmachine do
      @connection.pubsub = mock('pubsub')

      open_connection
      close_connection

      # Use next tick to give eventmachine the chance to run pubsub.unsubscribe_proc
      EM.next_tick { @connection.pubsub.expects(:unsubscribe_proc).with('action_cable/User#lifo') }
    end
  end

  test "processing disconnect message" do
    open_connection

    @connection.websocket.expects(:close)
    message = { 'type' => 'disconnect' }.to_json
    @connection.process_internal_message message
  end

  test "processing invalid message" do
    open_connection

    @connection.websocket.expects(:close).never
    message = { 'type' => 'unknown' }.to_json
    @connection.process_internal_message message
  end

  protected
    def open_connection
      @connection.process
      @connection.send :on_open
    end

    def close_connection
      @connection.send :on_close
    end
end
