describe('Cable should expose all modules', function() {
  it('contains PING_IDENTIFIER', function() {
    expect(Cable.PING_IDENTIFIER).to.equal('_ping');
  });

  it('contains createConsumer function', function() {
    expect(typeof Cable.createConsumer).to.equal('function');
  });

  it('contains Connection class', function() {
    expect(typeof Cable.Connection).to.equal('function');
  });

  it('contains ConnectionMonitor class', function() {
    expect(typeof Cable.ConnectionMonitor).to.equal('function');
  });

  it('contains Subscription class', function() {
    expect(typeof Cable.Subscription).to.equal('function');
  });

  it('contains Subscriptions class', function() {
    expect(typeof Cable.Subscriptions).to.equal('function');
  });

  it('contains Consumer class', function() {
    expect(typeof Cable.Consumer).to.equal('function');
  });
});
