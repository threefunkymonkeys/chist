require "cuba"
require "cuba/render"
require "sequel"
require "i18n"
require "rack/protection"
require "shield"
require_relative "lib/chist"

Chist::Settings.load
DB = Chist::Database.connect Chist::Settings.get('db')

I18n.locale = :en
I18n.load_path = Dir['./locale/**/*.yml']

Cuba.settings[:render]= {:template_engine => :haml}
Cuba.use Rack::Session::Cookie, :secret => "ef9dfef977c094acfb5a642cdeb0f0be0258df5c1d58b8101aee0aae4e041ebedc02ba38d2b4a658"
Cuba.use Rack::Protection

Cuba.plugin Shield::Helpers
Cuba.plugin Cuba::Render

Dir["./lib/**/*.rb"].each     { |rb| require rb }
Dir["./models/**/*.rb"].each     { |rb| require rb }
Dir["./routes/**/*.rb"].each     { |rb| require rb }
Dir["./helpers/**/*.rb"].each     { |rb| require rb }

Cuba.plugin Chist::Helpers

Cuba.define do
  on get do
    on root do
      res.write render("./views/layouts/app.haml") {
        render("./views/home/home.haml")
      }
    end
  end

  on 'users' do
    run Chist::Users
  end

  on default do
    res.status = 404
    res.write render("./views/layouts/app.haml") {
      render("./views/errors/404.haml")
    }
  end
end
