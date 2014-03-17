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

        not_found!
      end

      on post do
        on root do
          begin
            signup = Signup.new(req.params)
            raise SignupException.new unless signup.valid?
            user = User.new(:email => req.params['email'], :name => req.params['name'] || '')
            user.password = req.params['password']
            if auth = session['chist.auth']
              user.send("#{auth[:provider]}_user=", auth[:uid])
            end
            user.save
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
          if login(User, req.params['email'], req.params['password'])
            remember(authenticated(User)) if req.params['remember_me']
            res.redirect "/dashboard"
          else
            res.redirect "/"
          end
        end

        not_found!
      end
    end
  end
end
