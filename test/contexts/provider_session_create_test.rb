require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe 'ProviderSessionCreate' do
  def setup
    User.dataset.delete
  end

  it 'should detect a duplicated provider' do
    user = User.spawn(:github_user => "kandalf")
    context = MiniTest::Mock.new
    context.expect(:current_user, user)

    ctx = ChistApp::Context::ProviderSessionCreate.new({}, "github", context)

    assert_equal :provider_duplicated, ctx.call
  end

  it 'should add a provider' do
    user = User.spawn(:github_user => nil)
    context = MiniTest::Mock.new
    context.expect(:current_user, user)
    auth = OmniAuth::AuthHash.new(:uid => "kandalf")

    ctx = ChistApp::Context::ProviderSessionCreate.new(auth, "github", context)

    assert_equal :provider_added, ctx.call
  end

  it 'should detect empty email' do
    user = User.spawn(:github_user => nil)
    context = MiniTest::Mock.new
    context.expect(:current_user, nil)

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '123545',
      :extra => {
        :name => 'Test',
        :email => ''
      }
    })

    ctx = ChistApp::Context::ProviderSessionCreate.new(OmniAuth.config.mock_auth[:github], "github", context)

    assert_equal :empty_email, ctx.call
  end

  it 'should detect existing account' do
    user = User.spawn(:email => 'test@example.com', :github_user => nil)
    context = MiniTest::Mock.new
    context.expect(:current_user, nil)

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '123545',
      :extra => {
        :name => 'Test',
        :email => 'test@example.com'
      }
    })

    ctx = ChistApp::Context::ProviderSessionCreate.new(OmniAuth.config.mock_auth[:github], "github", context)

    assert_equal :account_exists, ctx.call
  end

  it "should create user if it doesn't exist" do
    context = MiniTest::Mock.new
    context.expect(:current_user, nil)

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '123545',
      :extra => {
        :name => 'Test',
        :email => 'test@example.com'
      }
    })

    ctx = ChistApp::Context::ProviderSessionCreate.new(OmniAuth.config.mock_auth[:github], "github", context)

    assert_equal :user_created, ctx.call
  end
end
