require 'action_cable/adapters/redis/broadcaster'

module ActionCable
  module Adapters
    class Broadcaster

      attr_reader :broadcaster, :logger

      def initialize(config, logger)
        @broadcaster = adapter(config).broadcaster
        @logger = logger
      end

      def broadcast(channel, message)
        logger.info("[ActionCable] Broadcasting to #{channel}: #{message}")
        broadcaster.publish(channel, message.to_json)
      end

      private
        def adapter(config)
          adapter_name = config.config[:adapter] || 'redis'
          adapter = "ActionCable::Adapters::#{adapter_name.camelize}::Broadcaster"
          adapter.constantize.new(config.config)
        end
      
    end
  end
end