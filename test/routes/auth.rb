require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe ChistApp::Auth do

  def setup
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '123545',
      :extra => {
        :name => 'Test',
        :email => 'test@email.com'
      }
    })

    User.dataset.destroy
  end

  it 'should create an account with default API keys using external provider' do
    get '/auth/github/callback', {}, headers: {'omniauth.auth' => OmniAuth.config.mock_auth[:github]}

    user = User.find(email: 'test@email.com')
    assert(!user.nil?)
    assert_equal('test@email.com', user.email)
    assert_equal('Test', user.name)
    assert_equal('123545', user.github_user)
    assert(!user.user_api_keys.empty?)
  end

  it 'should add external provider to existing user' do
    user = User.spawn({password: 'test', github_user: nil})
    login user, 'test'

    get '/auth/github/callback', {}, headers: {'omniauth.auth' => OmniAuth.config.mock_auth[:github]}
    updated_user = User[user.id]
    assert_equal OmniAuth.config.mock_auth[:github].uid, updated_user.github_user
  end
end
