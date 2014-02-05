require "cuba"
require "sequel"
require "i18n"
require "rack/protection"
require "shield"
require_relative "lib/chist"

Cuba.use Rack::Session::Cookie, :secret => "ef9dfef977c094acfb5a642cdeb0f0be0258df5c1d58b8101aee0aae4e041ebedc02ba38d2b4a658"
Cuba.use Rack::Protection

Cuba.settings.merge! Settings.load

DB = Sequel.connect DatabaseUtil.connection_path(Cuba.settings['db'])

Dir["./lib/**/*.rb"].each        { |rb| require rb }
Dir["./models/**/*.rb"].each     { |rb| require rb }
Dir["./routes/**/*.rb"].each     { |rb| require rb }

Cuba.define do
  on get do
    on root do
      user = User.first
      puts user
      res.write "Homepage"
    end
  end
end
