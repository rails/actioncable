require "rubygems"
require "bundler"
gem 'minitest'
require "minitest/autorun"

Bundler.setup
Bundler.require :default, :test

require 'celluloid/test'
require 'puma'
require 'rails'
require 'action_cable'
require 'redis'

module ApplicationCable
  class Connection < ActionCable::Connection::Base
  end
end

Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

ActionCable::Server::Configuration.redis_path = Pathname.new('./test/redis.yml')
ActionCable::Server::Configuration.channels_path = Pathname.new('./test/fixtures/channels')

ActiveSupport.test_order = :sorted

class ActionCableTest < ActiveSupport::TestCase
  PORT = 420420

  setup :start_puma_server
  teardown :stop_puma_server

  def start_puma_server
    Celluloid.shutdown
    Celluloid.boot
    events = Puma::Events.new(StringIO.new, StringIO.new)
    binder = Puma::Binder.new(events)
    binder.parse(["tcp://0.0.0.0:#{PORT}"], self)
    @server = Puma::Server.new(app, events)
    @server.binder = binder
    @server.run
  end

  def stop_puma_server
    @server.stop(true)
  end

  def websocket_url
    "ws://0.0.0.0:#{PORT}/"
  end

  def log(*args)
  end

end
