module ChistApp::Helpers
  def not_found!
    res.redirect '/404'
  end

  def unauthorized!
    halt([401,
          {"Content-type" => "text/plain",
           "WWW-Authenticate" => "Token"},
          ["You're not authorized to perform this reuqest"]])
  end

  def authenticated_request
    api_key = UserApiKey.find(:key => req.env["HTTP_X_CHIST_AUTH"])

    if api_key && api_key.user
      authenticate(api_key.user)
    else
      false
    end
  end
end
