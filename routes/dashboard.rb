module Chist
  class Dashboard < Cuba
    define do
      res.redirect '/' unless current_user
      on get do
        on root do
          res.write render("./views/layouts/app.haml") {
            render("./views/dashboard/index.haml")
          }
        end
      end
    end
  end
end
