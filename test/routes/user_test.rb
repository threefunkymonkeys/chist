require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe Chist::Users do
  def setup
    User.all.each { |user| user.delete }
  end

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
end
