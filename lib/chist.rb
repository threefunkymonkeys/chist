ENV['RACK_ENV'] ||= "development"
require 'yaml'

module Chist
  class Settings
    @@config = {}

    def self.get(key = nil)
      key.nil? ? @@config : @@config[key]
    end

    def self.load(path_relative = "/../config/settings.yml")
      begin
        @@config = YAML.load_file(File.dirname(__FILE__) + path_relative)[ENV['RACK_ENV']]
      rescue => e
        puts e.message
        abort("Can't load settings file")
      end
    end
  end

  class Database
    def self.connect(settings)
      Sequel.connect connection_path(settings)
    end

    private
      def self.connection_path(settings)
        "postgres://#{settings['user']}:#{settings['password']}@#{settings['host']}:#{settings['port']}/#{settings['db_name']}"
      end
  end
end
