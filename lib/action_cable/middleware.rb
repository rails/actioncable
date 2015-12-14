require 'faye/websocket'
module ActionCable
  class Middleware
    def initialize(app, options={})
      @app = app
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ActionCable.server.call(env)
      else
        @app.call(env)
      end
    end
  end
end
