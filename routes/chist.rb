class ChistApp::Routes < Cuba
  define do
    on "services" do
      run ChistApp::Services
    end

    on api_request do
      run ChistApp::ApiRoutes
    end

    on 'password/reset' do
      on authenticated(User) do
        on get do
          res.write render("./views/layouts/app.haml") {
            render("./views/users/password_reset.haml")
          }
        end

        on put do
          begin
            raise StandardError.new(I18n.t("user.password_doesnt_match")) unless req.params['new_password'] == req.params['confirm_password']
            current_user.password = req.params['new_password']
            current_user.update_password = false
            current_user.save
            flash[:success] = I18n.t('user.password_changed')
            res.redirect '/'
          rescue StandardError => e
            flash[:error] = e.message
            res.redirect '/password/reset'
          end
        end
        not_found!
      end
      not_found!
    end

    on current_user && current_user.update_password do
      res.redirect '/password/reset'
    end

    on 'auth' do
      run ChistApp::Auth
    end

    on 'users' do
      on 'keys' do
        run ChistApp::UserApiKeys
      end

      run ChistApp::Users
    end

    on 'dashboard' do
      run ChistApp::Dashboard
    end

    on 'chists' do
      run ChistApp::Chists
    end

    on 'search' do
      run ChistApp::Search
    end

    on 'terms' do
      res.write render("./views/layouts/public.haml") {
        render("./views/public/terms.haml")
      }
    end

    on 'privacy' do
      res.write render("./views/layouts/public.haml") {
        render("./views/public/privacy.haml")
      }
    end

    on get do
      on root do
        if current_user
          res.redirect('/chists/new')
        else
          res.write render("./views/layouts/home.haml") {
            render("./views/home/home.haml")
          }
        end
      end

      on '404' do
        res.write render("./views/layouts/app.haml") {
          render("./views/errors/404.haml")
        }
      end

      not_found!
    end

    not_found!
  end
end
