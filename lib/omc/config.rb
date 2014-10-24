require 'toml'

module Omc
  class Config
    PATHS = [
      File.join(ENV['HOME'], '.config', 'omcrc'),
      File.join(ENV['HOME'], '.omcrc'),
      '.omcrc'
    ]
    def self.load
      config = new
      PATHS.each do |path|
        config.load_file(path)
      end
      config
    end

    def load_file path
      return unless File.exists?(path)
      @config.update TOML.load_file(path)
    end

    def initialize(config={})
      @config = config
    end

    def account
      @config['account']
    end
  end
end
