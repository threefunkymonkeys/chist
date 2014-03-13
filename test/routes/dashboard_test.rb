require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe Chist::Dashboard do
  def setup
    User.all.each { |user| user.delete }
    @user = User.spawn(password: 'qwe123')
  end

  it 'should login user' do
    post '/users/login', {email: @user.email, password: 'qwe123'}

    get '/dashboard'
    assert_equal 200, last_response.status
  end

  it 'should not login user without password' do
    post '/users/login', {email: @user.email, password: ''}

    get '/dashboard'
    assert_equal 404, last_response.status
  end
end
