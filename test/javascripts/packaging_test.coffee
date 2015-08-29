expect = require('chai').expect;
Cable = require('../../lib/assets/javascripts/index.js.coffee');

describe 'Cable should expose all modules', ->
  it 'contains PING_IDENTIFIER', ->
    expect(Cable.PING_IDENTIFIER).to.equal '_ping'

  it 'contains createConsumer function', ->
    expect(typeof Cable.createConsumer).to.equal 'function'

  it 'contains Connection class', ->
    expect(typeof Cable.Connection).to.equal 'function'

  it 'contains ConnectionMonitor class', ->
    expect(typeof Cable.ConnectionMonitor).to.equal 'function'

  it 'contains Subscription class', ->
    expect(typeof Cable.Subscription).to.equal 'function'

  it 'contains Subscriptions class', ->
    expect(typeof Cable.Subscriptions).to.equal 'function'

  it 'contains Consumer class', ->
    expect(typeof Cable.Consumer).to.equal 'function'
