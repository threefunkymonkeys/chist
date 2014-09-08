require 'monkey-mailer'
require 'sequel'

module MonkeyMailer::Loaders
  class Sequel

    def initialize(sources)
      raise ArgumentError, 'You must define at least one database' unless sources.any?
      @pool = {}
      sources.each_pair do |name, opts|
        @pool[name.to_sym] = ::Sequel.connect(MonkeyMailer::Loaders::Sequel.connection_path(opts))
      end
    end

    def find_emails(priority, quota)
      emails = []
      MonkeyMailer.configuration.loader_options.each_key do |database|
        new_emails = MailQueue.where(:priority => priority.to_s).limit(quota)
        quota -= new_emails.count
        emails.concat(new_emails.all)
      end
      emails
    end

    def delete_email(email)
      email.destroy
    end

    private
    def self.connection_path(settings)
      "postgres://#{settings['user']}:#{settings['password']}@#{settings['host']}:#{settings['port']}/#{settings['db_name']}"
    end
  end
end
