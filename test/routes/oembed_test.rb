require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe 'ChistApp oEmbed Service' do
  before do
    User.dataset.destroy
    Chist.dataset.destroy

    @user = User.spawn
    @chist = Chist.spawn(user_id: @user.id)
  end

  it 'should return json+oembed response' do
    get "/services/oembed?url=#{URI.encode_www_form_component("#{ENV['SITE_URL']}/chists/#{@chist.id}")}&format=json"

    chist = Chist[@chist.id]

    last_response.status.must_equal 200

    response = JSON.parse(last_response.body)
    response['version'].must_equal "1.0"
    response['type'].must_equal "rich"
    response['provider_name'].must_equal "iChist"
    response['provider_url'].must_equal "http://ichist.com"
    response['title'].must_equal "#{chist.user.name}/#{chist.title}"
    response['author_name'].must_equal "#{chist.user.name}"
    response['html'].must_equal chist.chist.lines[0..4].join("\n")
  end
end
