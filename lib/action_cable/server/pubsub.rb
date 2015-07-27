require 'action_cable/adapters/pubsub'

module ActionCable
  module Server
    module Pubsub

      def pubsub
        @pubsub ||= ActionCable::Adapters::Pubsub.new(config).pubsub
      end

    end
  end
end