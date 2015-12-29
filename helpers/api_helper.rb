module ChistApp::Helpers
  def json(body, headers = {})
    headers["Content-type"] = "application/json"

    headers.keys.each do |k|
      req[k] = headers[k]
    end

    res.write body.to_json
  end
end
