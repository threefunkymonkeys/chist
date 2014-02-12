require "cuba"
require "cuba/render"
require "sequel"
require "i18n"
require "rack/protection"
require "shield"
require_relative "lib/chist"
require 'mail'
require 'omniauth-github'
require 'omniauth-twitter'
require 'omniauth-facebook'

ENV["RACK_ENV"] ||= :development
settings_file = File.join(File.dirname(__FILE__), "config/settings.yml")

Chist::Settings.load(settings_file, ENV["RACK_ENV"])
DB = Chist::Database.connect Chist::Settings.get('db')

I18n.locale = :en
I18n.load_path += Dir['./locale/**/*.yml']

Cuba.settings[:render]= {:template_engine => :haml}
Cuba.use Rack::Session::Cookie, :secret => "ef9dfef977c094acfb5a642cdeb0f0be0258df5c1d58b8101aee0aae4e041ebedc02ba38d2b4a658"
Cuba.use Rack::Protection

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

omniauth = Chist::Settings.get('omniauth')

Cuba.use OmniAuth::Builder do
  provider :github, omniauth['github_key'], omniauth['github_secret'], :scope => "user,repo"
  provider :facebook, omniauth['facebook_key'], omniauth['facebook_secret']
  provider :twitter, omniauth['twitter_key'], omniauth['twitter_secret']
end

Cuba.plugin Shield::Helpers
Cuba.plugin Cuba::Render

Dir["./lib/**/*.rb"].each     { |rb| require rb }
Dir["./models/**/*.rb"].each     { |rb| require rb }
Dir["./routes/**/*.rb"].each     { |rb| require rb }
Dir["./helpers/**/*.rb"].each     { |rb| require rb }
Dir["./context/**/*.rb"].each     { |rb| require rb }

Cuba.plugin Chist::Helpers
Cuba.plugin Chist::Context::Session
include Cuba::Render::Helper

Cuba.define do
  on 'auth' do
    run Chist::Auth
  end

  on 'users' do
    run Chist::Users
  end

  on 'dashboard' do
    run Chist::Dashboard
  end

  on get do
    on root do
      if current_user
        res.redirect('/dashboard')
      else
        res.write render("./views/layouts/app.haml") {
          render("./views/home/home.haml")
        }
      end
    end
  end

  on default do
    res.status = 404
    res.write render("./views/layouts/app.haml") {
      render("./views/errors/404.haml")
    }
  end
end
