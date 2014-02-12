module Chist
  class Auth < Cuba
    define do
      on get do
        on ':provider/callback' do |provider|
          auth_hash = @env['omniauth.auth']
          if current_user
            current_user.send("#{provider}_user=", auth_hash.uid)
            current_user.save
            flash[:success] = I18n.t("auth.#{provider}")
            res.redirect '/dashboard'
          elsif user = User.find(:"#{provider}_user" => auth_hash.uid)
            authenticate(user)
            res.redirect '/dashboard'
          else
          end
        end
      end
    end
  end
end
