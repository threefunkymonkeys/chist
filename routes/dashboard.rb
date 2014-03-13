module Chist
  class Dashboard < Cuba
    define do
      on authenticated(User) do
        on get do
          on root do
            res.write render("./views/layouts/app.haml") {
              render("./views/dashboard/index.haml")
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
