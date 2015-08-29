#= require_self
#= require cable/connection
#= require cable/connection_monitor
#= require cable/subscriptions
#= require cable/subscription
#= require cable/consumer

@Cable =
  PING_IDENTIFIER: "_ping"

  createConsumer: (url) ->
    new Cable.Consumer url
