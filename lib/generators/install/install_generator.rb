require 'rails/generators/named_base'

module ActionCable
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      desc 'Creates the Ruby and CoffeeScript files to support Action Cable'
      source_root File.expand_path('../templates', __FILE__)

      hook_for :test_framework

      def create_install_files
        unless File.exist?('app/channels/application_cable/channel.rb')
          template 'application_cable_channel.rb.erb', File.join('app/channels/application_cable', class_path, 'channel.rb')
        end
        unless File.exist?('app/channels/application_cable/connection.rb')
          template 'application_cable_connection.rb.erb', File.join('app/channels/application_cable', class_path, 'connection.rb')
        end
        unless File.exist?('app/assets/javascripts/channels/index.coffee')
          template 'index.coffee.erb', File.join('app/assets/javascripts/channels', 'index.coffee')
        end
        unless File.exist?('config/redis/cable.yml')
          template 'cable.yml.erb', File.join('config/redis', class_path, 'cable.yml')
        end
      end

      def create_action_cable_route
        route "match '/#{application_name}_cable', to: ActionCable.server, via: [:get, :post]"
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
