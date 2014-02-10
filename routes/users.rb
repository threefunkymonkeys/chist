module Chist
  class Users < Cuba
    define do
      on get do
        on 'logout' do
          logout(User)
          res.redirect '/'
        end
      end

      on post do
        on root do
          begin
            signup = Signup.new(req.params)
            raise SignupException.new unless signup.valid?
            user = User.new(:email => req.params['email'])
            user.password = req.params['password']
            user.save
            flash[:success] = I18n.t('home.user_created')
          rescue SignupException => e
            flash[:error] = signup.errors
            res.status = 400
          end
          res.redirect '/'
        end

        on 'login' do
          if login(User, req.params['email'], req.params['password'])
            remember(authenticated(User)) if req.params['remember_me']
            res.redirect "/dashboard"
          else
            res.redirect "/"
          end
        end
      end
    end
  end
end
