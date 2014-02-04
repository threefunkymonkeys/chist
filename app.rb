require "cuba"
require "sequel"
require "i18n"
require "rack/protection"

Dir["./lib/**/*.rb"].each        { |rb| require rb }
Dir["./models/**/*.rb"].each     { |rb| require rb }
Dir["./routes/**/*.rb"].each     { |rb| require rb }


Cuba.use Rack::Session::Cookie, :secret => "ef9dfef977c094acfb5a642cdeb0f0be0258df5c1d58b8101aee0aae4e041ebedc02ba38d2b4a658"
Cuba.use Rack::Protection

Cuba.define do
  on get do
    on root do
      res.write "Homepage"
    end
  end
end
