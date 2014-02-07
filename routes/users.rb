module Chist
  class Users < Cuba
    define do
      on post do
        on root do
          begin
            signup = Signup.new(req.params)
            raise SignupException.new unless signup.valid?
            user = User.new(:email => req.params['email'])
            user.password = req.params['password']
            user.save
            res.status = 201
            #flash message
          rescue SignupException => e
            #flash message
            puts signup.errors
            res.status = 400
          end
          res.redirect '/'
        end
      end
    end
  end
end
