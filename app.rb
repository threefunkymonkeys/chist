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
require 'hatch'

ENV["RACK_ENV"] ||= :development
settings_file = File.join(File.dirname(__FILE__), "config/settings.yml")

ChistApp::Settings.load(settings_file, ENV["RACK_ENV"])
DB = ChistApp::Database.connect ChistApp::Settings.get('db')
Sequel::Model.plugin :timestamps

I18n.enforce_available_locales = false
I18n.locale = :en
I18n.load_path += Dir['./locale/**/*.yml']

Cuba.settings[:render]= {:template_engine => :haml}
Cuba.use Rack::Session::Cookie, :secret => "ef9dfef977c094acfb5a642cdeb0f0be0258df5c1d58b8101aee0aae4e041ebedc02ba38d2b4a658"
Cuba.use Rack::Protection
Cuba.use Rack::MethodOverride

Cuba.use Rack::Static,
          root: File.expand_path(File.dirname(__FILE__)) + "/public",
          urls: %w[/img /css /js]

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

omniauth = ChistApp::Settings.get('omniauth')

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
Dir["./validators/**/*.rb"].each     { |rb| require rb }

Cuba.plugin ChistApp::Helpers
Cuba.plugin ChistApp::Context::Session
Cuba.plugin ChistApp::Validators

include Cuba::Render::Helper

Cuba.define do
  on 'password/reset' do
    on authenticated(User) do
      on get do
        res.write render("./views/layouts/app.haml") {
          render("./views/users/password_reset.haml")
        }
      end

      on put do
        begin
          raise StandardError.new(I18n.t("user.password_doesnt_match")) unless req.params['new_password'] == req.params['confirm_password']
          current_user.password = req.params['new_password']
          current_user.update_password = false
          current_user.save
          flash[:success] = I18n.t('user.password_changed')
          res.redirect '/'
        rescue StandardError => e
          flash[:error] = e.message
          res.redirect '/password/reset'
        end
      end
      not_found!
    end
    not_found!
  end

  on current_user && current_user.update_password do
    res.redirect '/password/reset'
  end

  on 'auth' do
    run ChistApp::Auth
  end

  on 'users' do
    run ChistApp::Users
  end

  on 'dashboard' do
    run ChistApp::Dashboard
  end

  on 'chists' do
    run ChistApp::Chists
  end

  on get do
    on root do
      if current_user
        res.redirect('/chists/new')
      else
        res.write render("./views/layouts/home.haml") {
          render("./views/home/home.haml")
        }
      end
    end

    on '404' do
      res.write render("./views/layouts/app.haml") {
        render("./views/errors/404.haml")
      }
    end

    on authenticated(User) do
      on "search" do
        chists = current_user.search_chists(req.params["query"])
        if req.xhr?
          res.write render("./views/dashboard/index.haml", :chists => chists)
        else
          res.write render("./views/layouts/app.haml") {
            render("./views/dashboard/index.haml", chists: chists)
          }
        end
      end
    end

    not_found!
  end

  not_found!
end
