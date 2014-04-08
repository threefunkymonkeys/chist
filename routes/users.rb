module ChistApp
  class Users < Cuba
    define do
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
            if auth = session['chist.auth']
              user.send("#{auth[:provider]}_user=", auth[:uid])
            end
            user.save
            Mailer.send_validation_code(user)
            session.delete('chist.auth')
            flash[:success] = I18n.t('home.user_created')
            res.redirect '/'
          rescue SignupException => e
            flash[:error] = signup.errors
            res.status = 400
            res.redirect req.params.has_key?('origin') ? req.params['origin'] : '/'
          end
        end

        on 'login' do
          begin
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
    end
  end
end
