module ChistApp::Context
  class ProviderSessionCreate
    attr_reader :user

    def initialize(auth_info, provider, context)
      @user = context.current_user
      @provider = provider
      @auth_info = auth_info
    end

    def call
      if @user
        return :provider_duplicated if @user.has_provider?(@provider)
        return :provider_added if @user.add_provider(@provider, @auth_info.uid)
      elsif @user = User.find(:"#{@provider}_user" => @auth_info.uid)
        authenticate(@user)
        return :user_authenticated
      else
        auth_hash = @auth_info.to_signup_hash
        if auth_hash[:email].empty?
          session['chist.auth'] = auth_hash
          return :empty_email
        else
          if User.find(:email => auth_hash[:email])
            return :account_exists
          else
            @user = User.create(
              :email => auth_hash[:email],
              :name => auth_hash[:name],
              :password => SecureRandom.hex(15),
              :validation_code => SecureRandom.hex(24),
              :update_password => true,
              :"#{@provider}_user" => @auth_info.uid
            )
            return :user_created
          end
        end
      end
    end
  end
end
