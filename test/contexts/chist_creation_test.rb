require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe 'ChistCreation' do

  it 'should create chist' do
    user = User.spawn
    context = MiniTest::Mock.new
    context.expect(:current_user, user)

    params = {
      'chist' => {
        'title' => Faker::Lorem.sentence(1),
        'chist' => Faker::Lorem.paragraph,
        'format' => 'none'
      }
    }

    ctx = ChistApp::Context::ChistCreation.new(params['chist'], context)

    assert_equal :success, ctx.call
  end

  it 'should not create an invalid chist' do
    user = User.spawn
    context = MiniTest::Mock.new
    context.expect(:current_user, user)

    params = {
      'chist' => {
        'chist' => Faker::Lorem.paragraph,
        'format' => 'none'
      }
    }

    ctx = ChistApp::Context::ChistCreation.new(params['chist'], context)

    assert_equal :error, ctx.call
    assert ctx.error_message.include?("title")
  end
end
