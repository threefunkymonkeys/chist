module ChistApp
  class ApiRoutes < Cuba
    define do
      unauthorized! unless authenticated_request

      on post do
        on 'chists' do
          attrs = chist_params_from_request

          ctx = ChistApp::Context::ChistCreation.new(attrs, self)

          result = ctx.call

          if result == :success
            body = { :chist => ctx.chist.to_hash.merge(:url => "#{ENV["SITE_URL"]}/#{ctx.chist.url}") }

            headers = { "Location" => body[:chist][:url] }

            res.status = 201

            json(body, headers)
          else
            res.status = 500
            res.write("Internal Server Error")
            halt res.finish
          end

        end
      end

      on get do
        on 'chists' do
          res.status = 200
          json(:chists => current_user.latest_chists.map(&:to_hash))
        end
      end
    end
  end
end
