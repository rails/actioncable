require 'action_cable/adapters/broadcaster'

module ActionCable
  module Server
    # Broadcasting is how other parts of your application can send messages to the channel subscribers. As explained in Channel, most of the time, these
    # broadcastings are streamed directly to the clients subscribed to the named broadcasting. Let's explain with a full-stack example:
    #
    #   class WebNotificationsChannel < ApplicationCable::Channel
    #      def subscribed
    #        stream_from "web_notifications_#{current_user.id}"
    #      end
    #    end
    #
    #    # Somewhere in your app this is called, perhaps from a NewCommentJob
    #    ActionCable.server.broadcast \
    #      "web_notifications_1", { title: 'New things!', body: 'All shit fit for print' }
    #
    #    # Client-side coffescript which assumes you've already requested the right to send web notifications
    #    App.cable.subscriptions.create "WebNotificationsChannel",
    #      received: (data) ->
    #        new Notification data['title'], body: data['body']
    module Broadcasting
      # Broadcast a hash directly to a named <tt>broadcasting</tt>. It'll automatically be JSON encoded.
      def broadcast(broadcasting, message)
        broadcaster.broadcast(broadcasting, message)
      end

      private
        def broadcaster
          @broadcaster ||= ActionCable::Adapters::Broadcaster.new(config, logger)
        end

    end
  end
end