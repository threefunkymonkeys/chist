module ChistApp
  class Users < Cuba
    define do
      on 'keys' do
        run ChistApp::UserApiKeys
      end

      on get do
        on 'logout' do
          logout(User)
          res.redirect '/'
        end

        on 'signup' do
          res.write render("./views/layouts/app.haml") {
            render("./views/users/signup.haml", auth: session['chist.auth'])
          }
        end

        on ':id/activate/:code' do |id, code|
          user = User[id]
          if user && user.validation_code ==  code
            user.activate
            flash[:success] = I18n.t('home.user_activated')
            res.redirect '/'
          else
            not_found!
          end
        end

        on authenticated(User) do
          on 'edit' do
            res.write render("./views/layouts/app.haml") {
              render("./views/users/edit.haml", user: current_user)
            }
          end

          on 'connections' do
            res.write render("./views/layouts/app.haml") {
              render("./views/users/connections.haml", user: current_user)
            }
          end

          on 'password' do
            res.write render("./views/layouts/app.haml") {
              render("./views/users/password.haml")
            }
          end

          not_found!
        end

        not_found!
      end

      on put do
        on authenticated(User) do
          on root do
            current_user.name = req.params['name']
            current_user.username = req.params['username']
            if current_user.save
              flash[:success] = I18n.t('user.user_edited')
              res.redirect '/'
            else
              flash[:success] = I18n.t('user.error_editing')
              res.redirect '/users/edit'
            end
          end

          on 'password' do
            begin
              raise StandardError.new(I18n.t('user.wrong_password')) unless Shield::Password.check(req.params['old_password'], current_user.crypted_password)
              raise StandardError.new(I18n.t('user.same_password')) unless req.params['old_password'] != req.params['new_password']
              raise StandardError.new(I18n.t('user.password_doesnt_match')) unless req.params['new_password'] == req.params['confirm_password']
              current_user.password = req.params['new_password']
              current_user.save
              flash[:success] = I18n.t('user.password_changed')
              res.redirect '/'
            rescue => e
              flash[:error] = e.message
              res.redirect '/users/password'
            end
          end

          not_found!
        end

        not_found!
      end

      on post do
        on root do
          begin
            signup = Signup.new(req.params)
            raise SignupException.new unless signup.valid?
            user = User.new(
              :email => req.params['email'],
              :name => req.params['name'] || '',
              :password => req.params['password'],
              :validation_code => SecureRandom.hex(24)
            )
            if auth = session['chist.auth'] && !session['chist.auth'][:uid].nil?
              user.send("#{auth[:provider]}_user=", auth[:uid])
            end
            user.save
            Mailer.send_validation_code(user)
            session.delete('chist.auth')
            flash[:success] = I18n.t('home.user_created')
            res.redirect '/'
          rescue SignupException => e
            flash[:error] = signup.errors.collect { |k,v| I18n.t("home.#{v.first}") }.flatten.join("; ")
            res.status = 400
            res.redirect req.params.has_key?('origin') ? req.params['origin'] : '/'
          end
        end

        on 'login' do
          begin
            if User[email: req.params['email']].nil?
              session['chist.auth'] = { name: "", email: req.params['email'] }
              redirect! '/users/signup'
            end

            raise LoginException.new(I18n.t('home.login.login_error')) unless login(User, req.params['email'], req.params['password'])
            user = authenticated(User)
            raise LoginException.new(I18n.t('home.login.account_not_validated')) unless user.valid
            remember(user) if req.params['remember_me']
            res.redirect "/dashboard"
          rescue LoginException => e
            logout(User)
            flash[:error] = e.message
            res.redirect "/"
          end
        end

        not_found!
      end

      on delete do
        on 'connections/:provider' do |provider|
          current_user.send("#{provider}_user=", nil)
          current_user.save
          flash[:success] = I18n.t("user.connection_deleted")
          res.redirect '/users/connections'
        end

        not_found!
      end
    end
  end
end
