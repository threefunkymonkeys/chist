require 'haml'

module ChistApp::Helpers
  class Mailer
    FROM_EMAIL = ENV['MAILER_FROM_EMAIL'] || "info@example.com"
    FROM_NAME  = ENV['MAILER_FROM_NAME']  || "Example"

    def self.send_validation_code(user)
      template = File.read('views/emails/account_validation.haml')
      subject  = I18n.t('emails.subject.validation')
      body = self.load_body(template, {user: user, url: ENV['SITE_URL']})
      user.name = user.email if user.name.empty?

      self.enqueue(user, subject, body, :urgent)
    end

    def self.enqueue(user, subject = '', body = '', priority = :normal)
      ::MailQueue.create({
        priority: priority.to_s,
        from_email: FROM_EMAIL,
        from_name: FROM_NAME,
        to_email: user.email,
        to_name: user.name,
        subject: subject,
        body: body
      })
    end

    def self.load_body(template, locals = {})
      ::Haml::Engine.new(template).render(Object.new, locals)
    end
  end
end
