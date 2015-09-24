require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe 'ContactCreation' do

  it 'should create contact' do
    context = MiniTest::Mock.new

    params = {
      'contact' => {
        'name'    => Faker::Lorem.sentence(1),
        'email'   => Faker::Lorem.sentence(1),
        'message' => Faker::Lorem.paragraph,
        'sample'  => Faker::Lorem.paragraph,
      }
    }

    ctx = ChistApp::Context::ContactCreation.new(params['contact'], context)

    assert_equal :success, ctx.call
  end

  it 'should not create an invalid chist' do
    user = User.spawn
    context = MiniTest::Mock.new
    context.expect(:current_user, user)

    params = {
      'contact' => {
        'name'    => Faker::Lorem.sentence(1),
        'email'   => Faker::Lorem.sentence(1),
        'message' => ''
      }
    }

    ctx = ChistApp::Context::ContactCreation.new(params['contact'], context)

    assert_equal :error, ctx.call
    assert ctx.error_message.include?("message")
  end
end
