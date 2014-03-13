require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe Chist::Auth do

  def setup
    User.all.each { |user| user.delete }
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '123545',
      :extra => {
        :name => 'Test',
        :email => 'test@email.com'
      }
    })
  end

  it 'should create an account using external provider' do
    get '/auth/github/callback', {}, headers: {'omniauth.auth' => OmniAuth.config.mock_auth[:github]}

    user = User.find(email: 'test@email.com')
    assert(!user.nil?)
    assert_equal('test@email.com', user.email)
    assert_equal('Test', user.name)
    assert_equal('123545', user.github_user)
  end
end
