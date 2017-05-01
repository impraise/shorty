module Shorty
  class Config
    def initialize(config_file = nil)
      @config_file =
        config_file || File.dirname(__FILE__) + '/../../config/shorty_config.rb'
    end

    def fetch(key)
      config.fetch(key)
    end

    def [](key)
      config[key]
    end

    private

    def config
      return @config if @config

      raise "#{@config_file} doesn't exist" unless File.exist?(@config_file)

      config = {}
      eval(File.read(@config_file))
      @config = config
    end
  end
end
