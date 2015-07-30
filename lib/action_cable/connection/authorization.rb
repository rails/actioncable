module ActionCable
  module Connection
    module Authorization
      class UnauthorizedError < StandardError; end

      private
        def reject_unauthorized_connection(message = "An unauthorized connection attempt was rejected")
          logger.error message
          raise UnauthorizedError
        end
    end
  end
end
