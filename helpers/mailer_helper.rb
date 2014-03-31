require 'haml'

module ChistApp::Helpers
  class Mailer
    def self.send_validation_code(user)
      template = File.read('views/emails/account_validation.haml')
      mail = Mail.new do
        from     'no-reply@chist.com'
        to       user.email
        subject  I18n.t('emails.subject.validation')
        body     ::Haml::Engine.new(template).render(Object.new, {user: user})
      end

      send(mail)
    end

    def self.send(mail)
      return unless ENV['RACK_ENV'] == :production
      mail.deliver
    end
  end
end
