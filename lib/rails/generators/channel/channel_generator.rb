require 'rails/generators/named_base'

module Rails
  module Generators
    class ChannelGenerator < Rails::Generators::NamedBase
      desc 'Creates the Ruby and CoffeeScript files to implement an Action Cable channel'
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision suffix: 'Channel'

      hook_for :test_framework

      def create_channel_files
        template 'channel.rb.erb', File.join('app/channels', class_path, "#{file_name}_channel.rb")
        template 'channel.coffee.erb', File.join('app/assets/javascripts/channels', "#{file_name}_channel.coffee")
      end
    end
  end
end
