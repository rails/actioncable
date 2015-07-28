require 'active_support/security_utils'

module ActionCable
  module Connection
    # Action Cable connection are protected from Cross-Site WebSocket Hijacking
    # (CSWSH) by using the same CSRF token protecting Rails' controllers.
    # When starting a Websocket connection the Action Cable javascript will
    # send along the CSRF token used to protect controllers. The token is
    # stored as a random string in the session, to which an attacker does not
    # have access. When a Websocket connection request reaches your
    # application, Action Cable verifies the received token with the token in
    # the session.
    #
    # CSWSH protection is turned on with the <tt>protect_from_hijacking</tt>
    # method.
    #
    # module ApplicationCable
    #   class Connection < ActionCable::Connection::Base
    #     protect_from_hijacking, if: -> { current_user.guest? }
    #   end
    # end
    #
    # Make sure that every page that requires starting a Websocket connection
    # includes in it's head the CSRF. This is accomplised by including
    # <tt>csrf_meta_tags</tt> in the HTML +head+. Action Cable needs to have
    # access to the meta tags so make sure that the <tt>csrf_meta_tags</tt> is
    # above the <tt>javascript_link_tag</tt> or the javascript / coffescript
    # creating the cable is executed on a domready event.
    #
    # Learn more about CSWSH attacks and securing your application:
    # {Cross-Site WebSocket Hijacking}[https://www.christian-schneider.net/CrossSiteWebSocketHijacking.html].
    # {Ruby on Rails Security Guide}[http://guides.rubyonrails.org/security.html].
    module HijackingProtection
      extend ActiveSupport::Concern

      AUTHENTICITY_TOKEN_LENGTH = 32

      module ClassMethods
        def protect_from_hijacking(options = {})
          options = options.reverse_merge(prepend: true)
          after_connect :validate_connection, options
        end
      end


      protected
      # This is the actual method verifying the token
      def validate_connection
        reject_unauthorized_connection "Invalid CSWSH/CSRF token" unless valid_authentication_token?(request.params["token"])
      end

      def valid_authentication_token?(encoded_masked_token)
        if encoded_masked_token.nil? || encoded_masked_token.empty? || !encoded_masked_token.is_a?(String)
          return false
        end

        begin
          masked_token = Base64.strict_decode64(encoded_masked_token)
        rescue ArgumentError # encoded_masked_token is invalid Base64
          return false
        end

        if masked_token.length == AUTHENTICITY_TOKEN_LENGTH
          # This is actually an unmasked token. This is expected if
          # you have just upgraded to masked tokens, but should stop
          # happening shortly after installing this gem
          compare_with_real_token masked_token, session

        elsif masked_token.length == AUTHENTICITY_TOKEN_LENGTH * 2
          # Split the token into the one-time pad and the encrypted
          # value and decrypt it
          one_time_pad = masked_token[0...AUTHENTICITY_TOKEN_LENGTH]
          encrypted_csrf_token = masked_token[AUTHENTICITY_TOKEN_LENGTH..-1]
          csrf_token = xor_byte_strings(one_time_pad, encrypted_csrf_token)

          compare_with_real_token csrf_token, session

        else
          false # Token is malformed
        end
      end

      def compare_with_real_token(token, session)
        ActiveSupport::SecurityUtils.secure_compare(token, real_csrf_token(session))
      end

      def real_csrf_token(session)
        session["_csrf_token"] ||= SecureRandom.base64(AUTHENTICITY_TOKEN_LENGTH)
        Base64.strict_decode64(session["_csrf_token"])
      end

      def xor_byte_strings(s1, s2)
        s1.bytes.zip(s2.bytes).map { |(c1,c2)| c1 ^ c2 }.pack('c*')
      end
    end
  end
end
