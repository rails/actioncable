module ActionCable
  module Adapters
    module Redis
      class Broadcaster

        attr_reader :config

        def initialize(config)
          @config = config
        end

        def broadcaster
          @broadcaster ||= ::Redis.new(config)
        end

      end
    end
  end
end