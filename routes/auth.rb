module ChistApp
  class Auth < Cuba
    define do
      on get do
        on ':provider/callback' do |provider|
          auth = @env['omniauth.auth']
          if current_user
            unless current_user.send("#{provider}_user") != auth.uid
              current_user.send("#{provider}_user=", auth.uid)
              current_user.save
              flash[:success] = I18n.t("auth.#{provider}")
              res.redirect '/dashboard'
            else
              flash[:warning] = I18n.t("auth.duplicated")
              res.redirect '/dashboard'
            end
          elsif user = User.find(:"#{provider}_user" => auth.uid)
            authenticate(user)
            res.redirect '/dashboard'
          else
            auth_hash = auth.to_signup_hash
            unless auth_hash[:email].empty?
              unless User.find(email: auth_hash[:email])
                user = User.new(
                  email: auth_hash[:email],
                  name: auth_hash[:name],
                  password: SecureRandom.hex(15),
                  validation_code: SecureRandom.hex(24),
                  update_password: true
                )
                user.send("#{provider}_user=", auth.uid)
                user.save
                Mailer.send_validation_code(user)
                flash[:success] = I18n.t('home.user_created')
                res.redirect '/'
              else
                flash[:warning] = I18n.t("auth.account_exists")
                res.redirect '/'
              end
            else
              session['chist.auth'] = auth_hash
              flash[:warning] = I18n.t("auth.missing_email")
              res.redirect '/users/signup'
            end
          end
        end
      end
    end
  end
end
