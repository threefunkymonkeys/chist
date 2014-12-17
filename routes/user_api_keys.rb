module ChistApp
  class UserApiKeys < Cuba
    define do
      on authenticated(User) do
        on get, root do
          res.write render("./views/layouts/app.haml") {
            render("./views/users/keys/index.haml", :keys => current_user.user_api_keys)
          }
        end

        on post do
          on root do
            key_attrs = { :name => req.params["name"],
                          :user_id => current_user.id,
                          :key => SecureRandom.hex(24) }
            key = UserApiKey.create(key_attrs)

            unless key && key.valid?
              flash[:error] = I18n.t('.user.create_key_error') 
            end

            res.redirect "/users/keys"
          end
        end

        on delete, ':id' do |k|
          key = UserApiKey.find(:key => k, :user_id => current_user.id)

          unless key && key.destroy
            flash[:error] = I18n.t('.user.delete_key_error')
          end

          res.redirect "/users/keys"
        end
      end
    end
  end
end
