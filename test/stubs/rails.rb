class Rails
  def self.logger
    ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(StringIO.new)
  end

  def self.root
    Pathname.new(File.dirname(__FILE__))
  end

  def self.env
    'TEST'
  end
end
