ENV['RACK_ENV'] ||= "development"
require 'yaml'

class Settings
  def self.load
    begin
      YAML.load_file(File.dirname(__FILE__) + "/../config/settings.yml")[ENV['RACK_ENV']]
    rescue => e
      puts e.message
      abort("Can't load settings file")
    end
  end
end

class DatabaseUtil
  def self.connection_path(settings)
    "postgres://#{settings['user']}:#{settings['password']}@#{settings['host']}:#{settings['port']}/#{settings['db_name']}"
  end
end
