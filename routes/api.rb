module ChistApp
  class ApiRoutes < Cuba
    define do
      on authenticated_request do
        on post do
          on 'chists' do
            attrs = chist_params_from_request

            ctx = ChistApp::Context::ChistCreation.new(attrs, self)

            result = ctx.call

            if result == :success
              body = { :chist => {
                      :url => "#{ENV["SITE_URL"]}/chists/#{ctx.chist.id}",
                      :created_at => Time.now } }

              headers = { "Content-type" => "application/json",
                          "Location" => body[:chist][:url] }

              halt [201, headers, body.to_json]
            else
              res.status = 500
              res.write("Internal Server Error")
              halt res.finish
            end

          end
        end
      end

      unauthorized!
    end
  end
end
