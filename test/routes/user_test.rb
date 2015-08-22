require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe ChistApp::Users do

  describe "User creation" do

    it 'should create user (201)' do
      password = Faker::Internet.password
      params = {
        'email' => Faker::Internet.safe_unique_email,
        'password' => password,
        'confirm_password' => password
      }
      post '/users', params

      assert_equal 302, last_response.status
      user = User.find(:email => params['email'])
      user.wont_be_nil
    end

    it 'should not create user (400)' do
      password = Faker::Internet.password
      params = {
        'email' => Faker::Internet.safe_unique_email,
        'password' => password,
      }
      post '/users', params

      assert_equal 302, last_response.status
      user = User.find(:email => params['email'])
      assert_equal nil, user
    end

    it 'should create default API key' do
      password = Faker::Internet.password
      params = {
        'email' => Faker::Internet.safe_unique_email,
        'password' => password,
        'confirm_password' => password
      }
      post '/users', params

      assert_equal 302, last_response.status
      user = User.find(:email => params['email'])
      user.wont_be_nil

      user.user_api_keys.wont_be_nil
    end
  end

  describe 'User activation' do
    it 'should activate account' do
      user = User.spawn({valid: false})
      assert_equal false, user.valid
      get "/users/#{user.id}/activate/#{user.validation_code}"
      assert_equal true, User[user.id].valid
    end
  end

  describe "User edition" do
    it 'should edit user profile' do
      user = User.spawn({password: 'test'})
      login user, 'test'

      new_name = Faker::Name.name
      new_username = Faker::Internet.user_name(new_name)
      params = {
        'name' => new_name,
        'username' => new_username
      }

      put '/users', params

      updated_user = User[user.id]
      assert_equal new_name, updated_user.name
      assert_equal new_username, updated_user.username
    end

    it 'should change password' do
      user = User.spawn({password: 'test'})
      login user, 'test'

      new_password = 'test1'

      params = {
        'old_password' => 'test',
        'new_password' => new_password,
        'confirm_password' => new_password
      }

      put '/users/password', params
      updated_user = User[user.id]

      assert_equal true, Shield::Password.check(new_password, updated_user.crypted_password)
    end
  end

  describe "User external connections" do
    it 'should delete external connection' do
      user = User.spawn({password: 'test', twitter_user: '1234'})
      login user, 'test'

      delete '/users/connections/twitter'
      updated_user = User[user.id]
      assert_equal nil, updated_user.twitter_user
    end
  end

  describe "User API keys" do
    before do
      User.dataset.destroy
      @user = User.spawn({password: 'test', twitter_user: '1234'})
      UserApiKey.create(:name => 'Default', :key => 'ABCDE', :user_id => @user.id)
    end

    describe "Authenticated user" do
      before do
        login @user, 'test'
      end

      it "should list API keys" do
        get '/users/edit'

        assert_equal(last_response.status, 200)
        assert(last_response.body.include? "ABCDE")
        assert(last_response.body.include? "Default")
      end

      it "should create new key" do
        login @user, 'test'
        params = { :name => "New Key", :user_id => @user.id }
        last_count = UserApiKey.count

        post "/users/keys", params

        assert_equal(last_count + 1, UserApiKey.count)
        assert(last_response.redirect?)

        assert_equal("/users/edit", last_response["Location"])
      end

      it "should delete key" do
        login @user, 'test'
        key = UserApiKey.create(:user_id => @user.id, :name => "Test", :key => SecureRandom.hex(24))

        delete "/users/keys/#{key.key}"

        key = UserApiKey.find(:user_id => @user.id, :key => key.key)

        assert(last_response.redirect?)
        assert(!key)
      end
    end

    describe "Anonymous user" do
      it "shouldn't access keys list" do
        get "/users/keys"

        assert(last_response.not_found?)
      end

      it "shouldn't create a new key" do
        params = { :name => "New Key", :user_id => @user.id }

        post "/users/keys", params

        assert(last_response.not_found?)
      end

      it "shouldn't delete a key" do
        key = UserApiKey.create(:user_id => @user.id, :name => "Test", :key => SecureRandom.hex(24))

        delete "/users/keys/#{key.key}"

        key = UserApiKey.find(:user_id => @user.id, :key => key.key)

        assert(last_response.not_found?)
        assert(key)
      end
    end
  end
end
