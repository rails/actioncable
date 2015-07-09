require 'rails/generators/named_base'

module Rails # :nodoc:
  module Generators # :nodoc:
    class ChannelGenerator < Rails::Generators::NamedBase # :nodoc:
      desc 'This generator creates a cable channel file in app/channels'
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision suffix: 'Channel'

      hook_for :test_framework

      def create_channel_files
        template 'channel.rb.erb', File.join('app/channels', class_path, "#{file_name}_channel.rb")
        template 'channel.coffee.erb', File.join('app/assets/javascripts/channels', "#{file_name}_channel.coffee")
      end

      def channel_name
        lass_name.camelize(:lower)
      end

      def channel_class
        "#{class_name}Channel"
      end
    end
  end
end
