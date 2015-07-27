require 'action_cable/adapters/redis/pubsub'

module ActionCable
  module Adapters
    class Pubsub

      attr_reader :pubsub

      def initialize(config)
        @pubsub = adapter(config).pubsub
      end

      private
        def adapter(config)
          adapter_name = config.config[:adapter] || 'redis'
          adapter = "ActionCable::Adapters::#{adapter_name.camelize}::Pubsub"
          adapter.constantize.new(config.config)
        end

    end
  end
end