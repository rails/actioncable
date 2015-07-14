require 'amqp'

module ActionCable
  module Adapters
    module RabbitMQ
      class Broadcaster

        attr_reader :config

        def initialize(config)
          @config = config
        end

        def broadcaster
          @rabbitmq ||= BroadcastInterface.new(config.rabbitmq)
        end

        class BroadcastInterface

          attr_reader :config

          def initialize(config)
            @config = config
          end

          def publish(queue, message)
            EventMachine.run do
              connection = AMQP.connect(config[:url])
              channel = AMQP::Channel.new(connection)
              exchange = channel.default_exchange
              exchange.publish(message, routing_key: queue) do
                connection.close { EM.stop }
              end
            end
          end

        end

      end
    end
  end
end