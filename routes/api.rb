module ChistApp
  class ApiRoutes < Cuba
    define do
      on authenticated_request do
        on post do
          on 'chists' do
          end
        end
      end

      unauthorized!
    end
  end
end
