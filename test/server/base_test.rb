require 'test_helper'

class ActionCable::Server::BaseTest < ActiveSupport::TestCase

  setup do
    mock_config

    @redis = MiniTest::Mock.new

    ActionCable::Server::Configuration.stub :new, @config do
      @base = ActionCable::Server::Base.new
    end
  end

  test "broadcast delivered to redis" do
    @redis.expect(:publish, nil, ["test_broadcasting", "test_message".to_json])

    Redis.stub :new, @redis do
      @base.broadcast "test_broadcasting", "test_message"
    end

    @redis.verify
  end

  def mock_config
    @config = MiniTest::Mock.new
    @config.expect(:redis, nil)
    def @config.logger
      ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(StringIO.new)
    end
  end
end
