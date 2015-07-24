require 'test_helper'

class ActionCable::Server::BaseTest < ActiveSupport::TestCase
  setup do
    @redis = MiniTest::Mock.new
    @base = ActionCable::Server::Base.new
  end

  test 'broadcast delivered to redis' do
    @redis.expect(:publish, nil, ['test_broadcasting', 'test_message'.to_json])

    Redis.stub :new, @redis do
      @base.broadcast 'test_broadcasting', 'test_message'
    end

    @redis.verify
  end
end
