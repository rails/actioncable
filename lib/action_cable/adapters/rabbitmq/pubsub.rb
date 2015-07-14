require 'amqp'

module ActionCable
  module Adapters
    module RabbitMQ
      class Pubsub

        attr_reader :config

        def initialize(config)
          @config = config
        end

        # The EventMachine Redis instance used by the pubsub adapter.
        def pubsub
          @pubsub ||= PubsubInterface.new(config.rabbitmq)
        end

        class PubsubInterface

          attr_reader :config

          def initialize(config)
            @config = config
          end

          def subscribe(channel_name, &callback)
            EventMachine.run do
              connection = AMQP.connect(config[:url])
              channel = AMQP::Channel.new(connection)
              queue = channel.queue(channel_name, :durable => true)
              consumer = AMQP::Consumer.new(channel, queue, nil, exclusive = false, no_ack = true)
              consumer.on_delivery do |_, message|
                callback.call(message)
              end
              consumer.consume
            end
          end

          def unsubscribe_proc(channel, callback)

          end

          

        end

      end
    end
  end
end