require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe 'Chist Route Helpers' do
  before do
    UserApiKey.dataset.delete
    User.dataset.delete
  end

  it 'should not take an API request without the auth header' do
    post '/chists', {}

    assert last_response.redirect?
    last_response["Location"].must_equal "/login"
  end

  it 'shoud authenticate API request' do
    user = User.spawn
    api_key = UserApiKey.create(:user_id => user.id,
                                :name => "Default",
                                :key => SecureRandom.hex(24))

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => api_key.key
    }

    params = { :chist => {
                    :title => "Test",
                    :chist => "12:00 <nickname> message",
                    :format => "irc" }}

    post '/chists', params.to_json, headers
    
    assert_equal 201, last_response.status
  end

  it 'should not authenticate an API request with another key' do
    user = User.spawn
    api_key = UserApiKey.create(:user_id => user.id,
                                :name => "Default",
                                :key => SecureRandom.hex(24))

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => 'ABCDEFGHIJKL'
    }

    post '/chists', {}, headers

    assert last_response.unauthorized?
    assert last_response.header["WWW-Authenticate"].include? "Digest"
  end
end
