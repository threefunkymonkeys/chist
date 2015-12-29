require File.expand_path(File.dirname(__FILE__)) + '/../../test_helper'

describe 'ChistApp::ApiRoutes' do
  before do
    User.dataset.destroy
    Chist.dataset.destroy
    UserApiKey.dataset.destroy

    @user = User.spawn
    UserApiKey.create(:user_id => @user.id, :name => "Default", :key => "1234")
  end

  it 'should not take an API request without the auth header' do
    get '/chists', {}
    puts last_response

    assert last_response.redirect?
    last_response["Location"].must_equal "/404"
  end

  it 'should list authenticated user chists' do
    headers = {
      "CONTENT_TYPE" => "application/json",
      "HTTP_ACCEPT" => "application/json",
      "HTTP_AUTHORIZATION" => @user.user_api_keys[0].key
    }

    chists = [Chist.spawn(:user_id => @user.id),
              Chist.spawn(:user_id => @user.id),
              Chist.spawn(:user_id => @user.id)]


    get "/chists", {}, headers

    last_response.status.must_equal 200

    response = JSON.parse(last_response.body)

    assert response["chists"].is_a?(Array)

    response["chists"].each do |c|
      assert chists.map(&:title).include? c["title"]
      assert chists.map(&:chist).include? c["chist"]
      assert chists.map(&:user_id).include? c["user_id"]
    end
  end
end
