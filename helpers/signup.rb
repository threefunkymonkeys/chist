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

      if assert_present('email') && assert_not_empty('email')
        assert_valid_email
        assert_unique_email
      end

      if assert_present('password') && assert_not_empty('password')
        assert_secure_password
      end

      if assert_present('confirm_password') && assert_not_empty('confirm_password')
        assert_password_confirmation
      end

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

      def assert_present(field, &block)
        result = @params.has_key?(field)
        add_error(field, 'not_missing') unless result
        result
      end

      def assert_not_empty(field)
        @params[field].strip!
        result = !@params[field].empty?
        add_error(field, 'not_empty') unless result
        result
      end

      def assert_secure_password
        result = @params['password'].size >= 6
        add_error('password', 'more_than_5_chars') unless result
        result
      end

      def assert_password_confirmation
        result =  @params['password'] == @params['confirm_password']
        add_error('confirm_password', 'match') unless result
        result
      end

      def assert_unique_email
        result = User.find(:email => @params['email']).nil?
        add_error('email', 'unique') unless result
        result
      end

      def assert_valid_email
        parsed = Mail::Address.new(@params['email'])
        result = parsed.address == @params['email'] && parsed.local != @params['email']
        add_error('email', 'valid') unless result
        result
      end
  end
end
