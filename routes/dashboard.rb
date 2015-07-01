module ChistApp
  class Dashboard < Cuba
    define do
      on authenticated(User) do
        on get do
          on root do

            res.write render("./views/layouts/app.haml") {
              chists = current_user.ordered_chists
              render("./views/dashboard/index.haml", chists: chists)
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
