require 'sprockets'

environment = Sprockets::Environment.new
environment.append_path 'lib/assets/javascripts'

environment.find_asset('cable.js.coffee').write_to('test/sprockets/cable.js');
