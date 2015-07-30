module ActionCable
  module Connection
    # = Action Cable Callbacks
    #
    # Action Cable provides hooks during the life cycle of a connection.
    # Callbacks allow you to trigger logic during the life cycle of a
    # connection. Available callbacks are:
    #
    # * <tt>after_connect</tt>
    # * <tt>after_disconnect</tt>
    #
    module Callbacks
      extend  ActiveSupport::Concern
      include ActiveSupport::Callbacks

      included do
        define_callbacks :connect, scope: :name
        define_callbacks :disconnect, scope: :name
      end

      module ClassMethods
        # Defines a callback that will get called right after the
        # connection is established.
        #
        #   module ApplicationCable
        #     class Connection < ActionCable::Connection::Base
        #       identified_by :current_user
        #       after_connect :prepare_connection
        #
        #       def prepare_connection
        #         self.current_user = find_verified_user
        #         logger.add_tags current_user.name
        #       end
        #     end
        #   end
        #
        def after_connect(*filters, &blk)
          set_callback(:connect, :before, *filters, &blk)
        end

        # Defines a callback that will get called right after the
        # connection is closed.
        #
        #   module ApplicationCable
        #     class Connection < ActionCable::Connection::Base
        #       identified_by :current_user
        #       after_disconnect :cleanup
        #
        #       def cleanup
        #         # Any cleanup work needed when the cable connection is cut.
        #       end
        #     end
        #   end
        #
        def after_disconnect(*filters, &blk)
          set_callback(:disconnect, :before, *filters, &blk)
        end
      end
    end
  end
end
