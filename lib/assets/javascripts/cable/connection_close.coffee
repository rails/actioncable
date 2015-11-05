class Cable.ConnectionClose
  identifier: Cable.CLOSE_IDENTIFIER

  constructor: (@consumer) ->
    @consumer.subscriptions.add(this)

  received: ->
    @consumer.connectionMonitor.stop()