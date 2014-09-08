require 'monkey-mailer'
require 'sequel'

class MailQueue < Sequel::Model
  one_to_many :attachments

  class Attachment < Sequel::Model
    many_to_one :mail_queue
  end
end

module MonkeyMailer::Loaders
  class Sequel
    @pool = {}

    def initialize(sources)
      raise ArgumentError, 'You must define at least one database' unless sources.any?
      sources.each_pair do |name, opts|
        @pool[name.to_sym] = Sequel.connect(opts)
      end
    end

    def find_emails(priority, quota)
      emails = []
      MonkeyMailer.configuration.loader_options.each_key do |database|
        new_emails = @pool[database.to_sym][:mail_queue].where(:priority => priority.to_s).limit(quota)
        quota -= new_emails.size
        emails.concat(new_emails)
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
