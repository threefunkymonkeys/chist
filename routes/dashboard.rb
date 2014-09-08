module ChistApp
  class Dashboard < Cuba
    define do
      on authenticated(User) do
        on get do
          on root do
            res.write render("./views/layouts/app.haml") {
              chists = current_user.ordered_chists
              if chists.any?
                render("./views/dashboard/index.haml", chists: chists)
              else
                res.redirect '/chists/new'
              end
            }
          end

          not_found!
        end

        not_found!
      end

      not_found!
    end
  end
end
