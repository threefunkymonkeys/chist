module Chist::Helpers
  class SignupException < StandardError; end
  class Signup
    attr_reader :errors

    def initialize(params = {})
      @params = params
      @errors = {}
    end

    def valid?
      reset_errors
      add_error('email', 'not_missing') unless assert_present('email')
      add_error('email', 'not_empty') unless assert_not_empty('email')
      add_error('email', 'unique') unless assert_unique_email
      add_error('password', 'not_missing') unless assert_present('password')
      add_error('password', 'not_empty') unless assert_not_empty('password')
      add_error('password', 'not_strong') unless assert_secure_password
      add_error('confirm_password', 'not_missing') unless assert_present('confirm_password')
      add_error('confirm_password', 'not_empty') unless assert_not_empty('confirm_password')
      add_error('confirm_password', 'not_match') unless assert_password_confirmation

      @errors.empty?
    end

    def add_error(key, error)
      @errors[key] = [] unless @errors.has_key?(key)
      @errors[key] << error
    end

    private
      def reset_errors
        @errors = {}
      end

      def assert_present(field)
        @params.has_key?(field)
      end

      def assert_not_empty(field)
        @params[field].strip!
        !@params.empty?
      end

      def assert_secure_password
        @params['password'].size >= 6
      end

      def assert_password_confirmation
        @params['password'] == @params['confirm_password']
      end

      def assert_unique_email
        User.find(:email => @params['email']).nil?
      end
  end
end
