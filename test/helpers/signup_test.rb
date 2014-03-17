require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe ChistApp::Helpers::Signup do
  def setup
    User.all.each { |user| user.delete }
  end

  it 'should validate new signup' do
    password = Faker::Internet.password
    params = {
      'email' => Faker::Internet.safe_unique_email,
      'password' => password,
      'confirm_password' => password
    }

    signup = ChistApp::Helpers::Signup.new(params)

    assert(signup.valid?)
  end

  it 'should not validate if there are missing params' do
    params = {
    }

    signup = ChistApp::Helpers::Signup.new(params)

    assert_equal(false, signup.valid?)
    assert_equal(true, signup.errors.any?)
    assert_equal(['not_missing'], signup.errors['email'])
    assert_equal(['not_missing'], signup.errors['password'])
    assert_equal(['not_missing'], signup.errors['confirm_password'])
  end

  it 'should not validate if there are empty params' do
    params = {
      'email' => '',
      'password' => '',
      'confirm_password' => ''
    }

    signup = ChistApp::Helpers::Signup.new(params)

    assert_equal(false, signup.valid?)
    assert_equal(true, signup.errors.any?)
    assert_equal(['not_empty'], signup.errors['email'])
    assert_equal(['not_empty'], signup.errors['password'])
    assert_equal(['not_empty'], signup.errors['confirm_password'])
  end

  it 'should not validate if email is invalid' do
    password = Faker::Internet.password
    params = {
      'email' => 'invalid_email',
      'password' => password,
      'confirm_password' => password
    }

    signup = ChistApp::Helpers::Signup.new(params)

    assert_equal(false, signup.valid?)
    assert_equal(true, signup.errors.any?)
    assert_equal(['valid'], signup.errors['email'])
  end

  it 'should not validate if email is not unique' do
    user = User.spawn
    password = Faker::Internet.password
    params = {
      'email' => user.email,
      'password' => password,
      'confirm_password' => password
    }

    signup = ChistApp::Helpers::Signup.new(params)

    assert_equal(false, signup.valid?)
    assert_equal(true, signup.errors.any?)
    assert_equal(['unique'], signup.errors['email'])
  end

  it 'should not validate if password is not strong' do
    password = Faker::Internet.password[0..4]
    params = {
      'email' => Faker::Internet.safe_unique_email,
      'password' => password,
      'confirm_password' => password
    }

    signup = ChistApp::Helpers::Signup.new(params)

    assert_equal(false, signup.valid?)
    assert_equal(true, signup.errors.any?)
    assert_equal(['more_than_5_chars'], signup.errors['password'])
  end

  it 'should not validate if confirm_password does not match' do
    params = {
      'email' => Faker::Internet.safe_unique_email,
      'password' => Faker::Internet.password,
      'confirm_password' => Faker::Internet.password
    }

    signup = ChistApp::Helpers::Signup.new(params)

    assert_equal(false, signup.valid?)
    assert_equal(true, signup.errors.any?)
    assert_equal(['match'], signup.errors['confirm_password'])
  end
end
