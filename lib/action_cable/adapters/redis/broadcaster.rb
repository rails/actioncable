module ActionCable
  module Adapters
    module Redis
      class Broadcaster

        attr_reader :config

        def initialize(config)
          @config = config
        end

        def broadcaster
          @redis ||= Redis.new(config.redis)          
        end

      end
    end
  end
end