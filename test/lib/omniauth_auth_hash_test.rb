require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe "OmniAuth::AuthHash#to_signup_hash" do

  it 'should return a hash' do
    object = OmniAuth::AuthHash.new
    hash = object.to_signup_hash

    assert_equal(Hash, hash.class)
  end

  it 'should have hash keys' do
    object = OmniAuth::AuthHash.new
    hash = object.to_signup_hash

    assert(hash.has_key?(:uid))
    assert(hash.has_key?(:provider))
    assert(hash.has_key?(:email))
    assert(hash.has_key?(:name))
  end

  it 'should extract fields for signup' do
    object = OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      :provider => 'twitter',
      :uid => '123545',
      :extra => {name: 'Test'},
      :info => {email: 'test@email.com'}
    })

    hash = object.to_signup_hash

    assert_equal('Test', hash[:name])
    assert_equal('test@email.com', hash[:email])
  end
end
