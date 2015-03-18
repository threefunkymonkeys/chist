class ChistApp::Services < Cuba
  define do
    on get, 'oembed' do
      not_found! if req.params["url"].nil?
      not_implemented! if req.params["format"].nil? ||  req.params["format"] != 'json'

      match = /\/chists\/(.+)$/.match(req.params["url"])
      not_found! unless match
      chist = Chist[match[1]]
      not_found! unless chist
      headers = { "Content-type" => "application/json" }
      body = {
        version: "1.0",
        type: "rich",
        provider_name: 'iChist',
        provider_url: 'http://ichist.com',
        title: "#{chist.user.name}/#{chist.title}",
        author_name: "#{chist.user.name}",
        html: chist.chist.lines[0..4].join("\n"),
        width: 600,
        height: 200
      }

      halt [200, headers, body.to_json]
    end
  end
end
