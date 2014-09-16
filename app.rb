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
require_relative "helpers/environment_helper"

ENV["RACK_ENV"] ||= :development

ChistApp::Helpers.init_environment(ENV["RACK_ENV"])

Sequel::Model.plugin :timestamps

I18n.enforce_available_locales = false
I18n.locale = :en
I18n.load_path += Dir['./locale/**/*.yml']

Cuba.settings[:render]= {:template_engine => :haml}
Cuba.use Rack::Session::Cookie, :secret => ENV["SESSION_SECRET"]
Cuba.use Rack::Protection
Cuba.use Rack::MethodOverride

Cuba.use Rack::Static,
          root: File.expand_path(File.dirname(__FILE__)) + "/public",
          urls: %w[/img /css /js /fonts]

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

omniauth = ChistApp::Settings.get('omniauth')

Cuba.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], :scope => "user"
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
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

  on 'search' do
    run ChistApp::Search
  end

  on 'terms' do
    res.write render("./views/layouts/public.haml") {
      render("./views/public/terms.haml")
    }
  end

  on 'privacy' do
    res.write render("./views/layouts/public.haml") {
      render("./views/public/privacy.haml")
    }
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

    not_found!
  end

  not_found!
end
