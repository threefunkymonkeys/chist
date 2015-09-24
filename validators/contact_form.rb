module ChistApp::Validators
  class ContactForm
    include Hatch

    certify('name', I18n.t('contact.errors.name')) do |name|
      !name.nil? && !name.empty?
    end

    certify('email', I18n.t('contact.errors.email')) do |email|
      !email.nil? && !email.empty?
    end

    certify('message', I18n.t('contact.errors.message')) do |message|
      !message.nil? && !message.empty?
    end
  end
end

