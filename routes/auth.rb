module ChistApp
  class Auth < Cuba
    define do
      on get do
        on ':provider/callback' do |provider|
          context = ChistApp::Context::ProviderSessionCreate.new(
                      @env['omniauth.auth'],
                      provider,
                      self
                   )
          result = context.call

          case result
          when :provider_duplicated
            flash[:warning] = I18n.t("auth.duplicated")
            redirect! '/chists/new'

          when :provider_added
            flash[:success] = I18n.t("auth.#{provider}")
            redirect! '/users/connections'

          when :user_authenticated
            redirect! '/chists/new'
          when :empty_email
            session['chist.auth'] = @env['omniauth.auth'].to_signup_hash
            flash[:warning] = I18n.t("auth.missing_email")
            redirect! '/users/signup'
          when :account_exists
            flash[:warning] = I18n.t("auth.account_exists")
            redirect! '/'

          when :user_created
            Mailer.send_validation_code(context.user)
            flash[:success] = I18n.t('home.user_created')
            redirect! '/'
          end
        end

        on 'failure' do
          flash[:error] = I18n.t('home.providers.error')
          redirect! '/'
        end
      end
    end
  end
end
