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

    post '/chists', {}, 'HTTP_X_CHIST_AUTH' => api_key.key
    
    assert last_response.ok?
  end

  it 'should not authenticate an API request with another key' do
    user = User.spawn
    api_key = UserApiKey.create(:user_id => user.id,
                                :name => "Default",
                                :key => SecureRandom.hex(24))

    post '/chists', {}, 'HTTP_X_CHIST_AUTH' => "ABCDEFGHIJKL"

    assert last_response.unauthorized?
  end
end
