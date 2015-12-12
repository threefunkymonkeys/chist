class ChistApp::Routes < Cuba
  define do
    on current_user && current_user.update_password do
      res.redirect '/password/reset'
    end

    on "services" do
      run ChistApp::Services
    end

    on api_request do
      run ChistApp::ApiRoutes
    end

    on 'auth' do
      run ChistApp::Auth
    end

    on 'users' do
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

    on 'password' do
      run ChistApp::Password
    end

    on 'contact' do
      run ChistApp::Contact
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

      on 'terms' do
        res.write render("./views/layouts/app.haml") {
          render("./views/public/terms.haml")
        }
      end

      on 'privacy' do
        res.write render("./views/layouts/app.haml") {
          render("./views/public/privacy.haml")
        }
      end

      not_found!
    end

    not_found!
  end
end
