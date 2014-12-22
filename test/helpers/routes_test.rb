require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
include ChistApp::Helpers

describe 'Chist Route Helpers' do
  before do
    UserApiKey.dataset.destroy
    User.dataset.destroy
  end

  it 'should detect API request via headers' do
    env = { "CONTENT_TYPE" => "application/json",
            "HTTP_ACCEPT" => "application/json",
            "HTTP_AUTHORIZATION" => "ABCDE" }

    req = Rack::Request.new(env)
    req.stubs(:env).returns(env)
    
    self.stubs(:req).returns(req)

    assert api_request
  end

  it 'should authenticate request from header' do
    user = User.spawn
    api_key = UserApiKey.create(:name => "Default", :key => SecureRandom.hex(24), :user_id => user.id)

    env = { "HTTP_AUTHORIZATION" => api_key.key }
    req = Rack::Request.new(env)

    self.stubs(:req).returns(req)

    self.expects(:authenticate).with(user)
  end
end
