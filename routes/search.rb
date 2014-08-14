module ChistApp
  class Search < Cuba
    define do
      on get, root do
        on authenticated(User) do
          chists = current_user.search_chists(req.params["query"])
          if req.xhr?
            res.write render("./views/dashboard/index.haml", :chists => chists)
          else
            res.write render("./views/layouts/app.haml") {
              render("./views/dashboard/index.haml", chists: chists)
            }
          end
        end

        not_found!
      end

      not_found!
    end
  end
end
