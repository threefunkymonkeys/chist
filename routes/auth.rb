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
            res.redirect '/chists/new'

          when :provider_added
            flash[:success] = I18n.t("auth.#{provider}")
            res.redirect '/users/connections'

          when :user_authenticated
            res.redirect '/chists/new'
          when :empty_email
            session['chist.auth'] = @env['omniauth.auth'].to_signup_hash
            flash[:warning] = I18n.t("auth.missing_email")
            res.redirect '/users/signup'

          when :user_created
            Mailer.send_validation_code(context.user)
            flash[:success] = I18n.t('home.user_created')
            res.redirect '/'
          end
        end

        on 'failure' do
          flash[:error] = I18n.t('home.providers.error')
          res.redirect '/'
        end
      end
    end
  end
end
