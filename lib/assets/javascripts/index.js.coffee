Cable =
  PING_IDENTIFIER: "_ping"

  createConsumer: (url) ->
    new Cable.Consumer url

if typeof window == 'object'
  window.Cable = Cable
else if typeof global == 'object'
  global.Cable = Cable

require('./cable/connection.js.coffee')
require('./cable/connection_monitor.js.coffee')
require('./cable/subscription.js.coffee')
require('./cable/subscriptions.js.coffee')
require('./cable/consumer.js.coffee')

module.exports = Cable;
