module ActionCable
  module Adapters
    module Redis
      class Pubsub

        attr_reader :config

        def initialize(config)
          @config = config
        end

        def pubsub
          @pubsub ||= redis_instance.pubsub
        end

        private
          def redis_instance
            EM::Hiredis.connect(config[:url]).tap do |redis|
              redis.on(:reconnect_failed) do
                logger.info "[ActionCable] Redis reconnect failed."
              end
            end
          end

      end
    end
  end
end