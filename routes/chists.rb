module ChistApp
  class Chists < Cuba
    define do
      on get do
        on authenticated(User) do
          on 'new' do
            res.write render("./views/layouts/app.haml") {
              render("./views/chists/new.haml")
            }
          end

          not_found!
        end

        not_found!
      end

      on post do
        on root do
          begin
            Chist.create({
              title:     req.params['title'],
              chist:     req.params['chist'],
              chist_raw: req.params['chist'],
              public:    req.params.has_key?('public'),
              user: current_user
            })
            flash[:success] = I18n.t('chists.chists_created')
            res.redirect '/dashboard'
          rescue => e
            res.write e.message
          end
        end

        not_found!
      end

      not_found!
    end
  end
end

