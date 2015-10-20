require 'ostruct'

class TestServer
  include ActionCable::Server::Connections

  attr_reader :logger, :config
  attr_accessor :pubsub_pool

  def initialize
    @logger = ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(StringIO.new)
    @config = OpenStruct.new(log_tags: [])
    @pubsub_pool = []
  end

  def send_async
  end
end
