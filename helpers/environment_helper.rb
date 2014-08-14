module ChistApp
  module Helpers
    def self.init_environment(env)
      self.set_env(env)

      settings_file = File.join(File.dirname(__FILE__), "/../config/settings.yml")
      ChistApp::Settings.load(settings_file, env)
      ChistApp::Database.connect ChistApp::Settings.get('db')
    end

    def self.set_env(env)
      filename = env.to_s + ".env.sh"

      if File.exists? filename
        env_vars = File.read(filename)
        env_vars.each_line do |var|
          name, value = var.split("=")
          ENV[name.strip] = value.strip
        end
      end
    end
  end
end
