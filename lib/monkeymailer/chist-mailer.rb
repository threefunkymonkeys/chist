require 'monkey-mailer'
require_relative 'mm-sequel'
require_relative 'mm-postmark-adapter'
require_relative "../chist"
require_relative "../../helpers/environment_helper"

ENV["RACK_ENV"] ||= "development"

ChistApp::Helpers.init_environment(ENV["RACK_ENV"])

module ChistMailer
  extend MonkeyMailer
  extend Fallen::CLI

  MonkeyMailer.configure do |config|
    case ENV['MAILER_ADAPTER']
    when 'smtp'
      config.adapter = MonkeyMailer::Adapters::Smtp
      config.adapter_options = {
        :address => ENV['SMTP_ADDRESS'] || '',
        :port => ENV['SMTP_PORT'] || '' ,
        :domain => ENV['SMTP_DOMAIN'] || '',
        :user_name => ENV['SMTP_USER'] || '',
        :password => ENV['SMTP_PASSWORD'] || '',
        :authentication => ENV['SMTP_AUTHENTICATION'] || 'plain',
        :enable_starttls_auto => ENV['SMTP_STARTTLS_AUTO'] || true
      }
    when 'mandril'
      config.adapter = MonkeyMailer::Adapters::MandrilAPI
      config.adapter_options = {:mandril_api_key => ENV['MANDRIL_API_KEY']}
    when 'postmark'
      config.adapter = MonkeyMailer::Adapters::Postmark
      config.adapter_options = {:postmark_api_token => ENV['POSTMARK_API_TOKEN']}
    else
      raise RuntimeError.new("Must select one adapter: mandril or smtp")
    end

    config.loader = MonkeyMailer::Loaders::Sequel
    config.loader_options = {
      :default => {
        'host' => ENV["DATABASE_HOST"],
        'port' => ENV["DATABASE_PORT"],
        'user' => ENV["DATABASE_USER"],
        'password' => ENV["DATABASE_PASS"],
        'db_name' => ENV["DATABASE_NAME"]
      }
    }

    config.urgent_quota = ENV['MM_URGENT_QUOTA'].to_i || 50
    config.normal_quota = ENV['MM_NORMAL_QUOTA'].to_i || 25
    config.low_quota    = ENV['MM_LOW_QUOTA'].to_i    || 5
    config.normal_sleep = ENV['MM_NORMAL_SLEEP'].to_i || 1
    config.low_sleep    = ENV['MM_LOW_SLEEP'].to_i    || 2
    config.sleep        = ENV['MM_SLEEP'].to_i        || 5
  end
end

require_relative 'models'
