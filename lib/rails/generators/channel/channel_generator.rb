require 'rails/generators/named_base'

module Rails
  module Generators
    class ChannelGenerator < Rails::Generators::NamedBase
      desc 'This generator creates the Ruby and Coffeescript files to support Actioncable'
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision suffix: 'Channel'

      hook_for :test_framework

      def create_channel_files
        initialize_actioncable_requirements
        template 'channel.rb.erb', File.join('app/channels', class_path, "#{file_name}_channel.rb")
        template 'channel.coffee.erb', File.join('app/assets/javascripts/channels', "#{file_name}_channel.coffee")
      end

      def initialize_actioncable_requirements
        unless File.exist?('app/channels/application_cable/channel.rb')
          template 'application_cable_channel.rb.erb', File.join('app/channels/application_cable', class_path, "channel.rb")
        end
        unless File.exist?('app/channels/application_cable/connection.rb')
          template 'application_cable_connection.rb.erb', File.join('app/channels/application_cable', class_path, "connection.rb")
        end
        unless File.exist?('app/assets/javascripts/channels')
          template 'index.coffee.erb', File.join('app/assets/javascripts/channels', "index.coffee")
        end
        unless File.read("app/assets/javascripts/application.js").include?("//= require channels")
          inject_into_file "app/assets/javascripts/application.js", "//= require channels\n", :before => "//= require_tree .\n"
        end
      end

      def channel_name
        class_name.camelize(:lower)
      end

      def channel_class
        "#{class_name}Channel"
      end
    end
  end
end
