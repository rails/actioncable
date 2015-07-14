module ActionCable
  module Adapters
    module Redis
      class Pubsub

        attr_reader :config

        def initialize(config)
          @config = config
        end

        # The EventMachine Redis instance used by the pubsub adapter.
        def pubsub
          @pubsub ||= EM::Hiredis.connect(config.redis[:url]).tap do |redis|
            redis.on(:reconnect_failed) do
              logger.info "[ActionCable] Redis reconnect failed."
              # logger.info "[ActionCable] Redis reconnected. Closing all the open connections."
              # @connections.map &:close
            end            
          end.pubsub
        end

      end
    end
  end
end