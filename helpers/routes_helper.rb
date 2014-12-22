module ChistApp::Helpers
  def not_found!
    res.redirect '/404'
  end

  def unauthorized!
    halt([401,
          {"Content-type" => "application/json",
           "WWW-Authenticate" => 'Digest realm="214af5b3da3c6b06e851496d7903a150"'},
          [{:message => "You're not authorized to perform this request"}]])
  end

  def api_request
    !!(req.env["CONTENT_TYPE"] == "application/json" &&
      req.env["HTTP_ACCEPT"] == "application/json" &&
      !req.env["HTTP_AUTHORIZATION"].nil?)
  end

  def authenticated_request
    api_key = UserApiKey.find(:key => req.env["HTTP_AUTHORIZATION"])

    if api_key && api_key.user
      authenticate(api_key.user)
    else
      false
    end
  end

  def chist_params_from_request
    body = req.body.read
    (body == "" ? {} : JSON.parse(body))
  end
end
