module ChistApp::Helpers
  def json(body, headers = {})
    headers["Content-type"] = "application/json"

    headers.each do |k, v|
      req[k] = v
    end

    res.write body.to_json
  end
end
