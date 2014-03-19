module ChistApp::Validators
  class SignupForm
    attr_reader :email, :password, :confirm_password
    include Hatch

    certify('email', 'users.errors.email') do |email|
      !email.nil? && !email.empty? && valid_email?(email) && unique_email?(email)
    end

    certify('password', 'users.errors.password') do |password|
      !password.nil? && !password.empty? && secure_pasword?(password)
    end

    certify('confirm_password', 'users.errors.confirm_password') do |password|
      !password.nil? && confirmation_match?(password)
    end

    def self.valid_email?(email)
      parsed = Mail::Address.new(email)
      parsed.address == email && parsed.local != email
    end

    def self.unique_email?(email)
      User.find(:email => email).nil?
    end

    def self.secure_pasword?(password)
      password.size >= 6
    end

    def self.confirmation_match?(password)
      password == self.password
    end
  end
end
