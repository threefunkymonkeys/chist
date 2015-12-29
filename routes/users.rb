module ChistApp
  class Users < Cuba
    define do
      on 'keys' do
        run ChistApp::UserApiKeys
      end

      on get do
        on 'logout' do
          logout(User)
          redirect! '/'
        end

        on 'signup' do
          redirect! '/' unless session['chist.auth']
          res.write render("./views/layouts/app.haml") {
            render("./views/users/signup.haml", auth: session['chist.auth'])
          }
        end

        on 'reset/:token' do |token|
      	  user = User.find( :token_reset => token)

          if user.nil?
            flash[:error] = I18n.t('user.reset_invalid_link')
            redirect! "/"
          end

          res.write render("./views/layouts/home.haml") {
            render("./views/users/password_reset.haml", token: token)
          }
        end

        on 'forgot' do
          res.write render("./views/layouts/home.haml") {
            render("./views/users/password_forgot.haml")
          }
        end

        on ':id/activate/:code' do |id, code|
          user = User[id]
          if user && user.validation_code ==  code
            user.activate
            flash[:success] = I18n.t('home.user_activated')
            redirect! '/'
          else
            not_found!
          end
        end

        on authenticated(User) do
          on 'edit' do
            res.write render("./views/layouts/app.haml") {
              render("./views/users/edit.haml", user: current_user, :keys => current_user.user_api_keys)
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
              res.redirect '/users/edit'
            else
              flash[:error] = I18n.t('user.error_editing')
            end
            redirect! '/users/edit'
          end

          on 'password' do
            begin
              raise StandardError.new(I18n.t('user.wrong_password')) unless Shield::Password.check(req.params['old_password'], current_user.crypted_password)
              raise StandardError.new(I18n.t('user.same_password')) unless req.params['old_password'] != req.params['new_password']
              raise StandardError.new(I18n.t('user.password_doesnt_match')) unless req.params['new_password'] == req.params['confirm_password']
              current_user.password = req.params['new_password']
              current_user.save
              flash[:success] = I18n.t('user.password_changed')
              redirect! '/users/edit'
            rescue => e
              flash[:error] = e.message
              redirect! '/users/edit'
            end
          end

          not_found!
        end

        on 'forgot' do
          user = User.find( :email => req.params['email'])

          if user.nil?
            flash[:error] = I18n.t('user.forgot_invalid_email')
            redirect! '/users/forgot'
          end

	  user.token_reset = SecureRandom.hex(24)
          user.save
          Mailer.send_forgot_password_link(user)

          flash[:success] = I18n.t('user.forgot_email_sent')
          res.redirect '/users/forgot'
        end

        on 'reset/:token' do |token|
          user = User.find( :token_reset => token)

          if user.nil?
            flash[:error] = I18n.t('user.reset_invalid_link')
          end

          if req.params['new_password'] != req.params['new_password']
            flash[:error] = 'Passwords not match'
          end

          user.password = req.params['new_password']
          user.token_reset = nil

          if user.save
            flash[:success] = I18n.t('user.reset_password_updated')
            res.redirect '/'
          else
            res.redirect '/users/reset/' + token
          end
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
            redirect! '/'
          rescue SignupException => e
            flash[:error] = signup.errors.collect { |k,v| I18n.t("home.#{v.first}") }.flatten.join("; ")
            res.status = 400
            redirect! req.params.has_key?('origin') ? req.params['origin'] : '/'
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
            redirect! "/dashboard"
          rescue LoginException => e
            logout(User)
            flash[:error] = e.message
            redirect! "/"
          end
        end

        not_found!
      end

      on delete do
        on 'connections/:provider' do |provider|
          current_user.send("#{provider}_user=", nil)
          current_user.save
          flash[:success] = I18n.t("user.connection_deleted")
          redirect! '/users/connections'
        end

        not_found!
      end

      not_found!
    end
  end
end
