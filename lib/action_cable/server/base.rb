require 'action_cable/adapters/redis/pubsub'
require 'action_cable/adapters/rabbitmq/pubsub'

module ActionCable
  module Server
    # A singleton ActionCable::Server instance is available via ActionCable.server. It's used by the rack process that starts the cable server, but
    # also by the user to reach the RemoteConnections instead for finding and disconnecting connections across all servers.
    #
    # Also, this is the server instance used for broadcasting. See Broadcasting for details.
    class Base
      include ActionCable::Server::Broadcasting
      include ActionCable::Server::Connections

      cattr_accessor(:config, instance_accessor: true) { ActionCable::Server::Configuration.new }
      
      def self.logger; config.logger; end
      delegate :logger, to: :config

      def initialize
      end

      # Called by rack to setup the server.
      def call(env)
        config.connection_class.new(self, env).process
      end

      # Gateway to RemoteConnections. See that class for details.
      def remote_connections
        @remote_connections ||= RemoteConnections.new(self)
      end

      # The thread worker pool for handling all the connection work on this server. Default size is set by config.worker_pool_size.
      def worker_pool
        @worker_pool ||= ActionCable::Server::Worker.pool(size: config.worker_pool_size)
      end

      # Requires and returns an array of all the channel class constants in this application.
      def channel_classes
        @channel_classes ||= begin
          config.channel_paths.each { |channel_path| require channel_path }
          config.channel_class_names.collect { |name| name.constantize }
        end
      end

      def adapter
        @adapter ||= ActionCable::Adapters::RabbitMQ::Pubsub.new(config)
      end

      # The redis pubsub adapter used for all streams/broadcasting.
      def pubsub
        @pubsub ||= adapter.pubsub
      end

      # All the identifiers applied to the connection class associated with this server.
      def connection_identifiers
        config.connection_class.identifiers
      end
    end
  end
end