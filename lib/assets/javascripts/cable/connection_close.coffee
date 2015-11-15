class Cable.ConnectionClose
  identifier: Cable.INTERNAL.identifiers.close

  constructor: (@consumer) ->
    @consumer.subscriptions.add(this)

  received: ->
    @consumer.connectionMonitor.stop()
