require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe ChistApp::Chists do

  it 'should create public chist (201)' do
    user = User.spawn(:password => 'test')

    params = {
      'chist' => {
        'title' => Faker::Lorem.sentence(1),
        'chist' => Faker::Lorem.paragraph,
        'format' => 'none',
        'public' => "1"
      }
    }

    login user, 'test'
    post '/chists', params

    chist = Chist.find(:title => params['chist']['title'])
    chist.wont_be_nil
    assert_equal true, chist.public
    assert_equal params['chist']['title'], chist.title
    assert_equal params['chist']['chist'], chist.chist
  end

  it 'should create private chist (201)' do
    user = User.spawn(:password => 'test')

    params = {
      'chist' => {
        'title' => Faker::Lorem.sentence(1),
        'chist' => Faker::Lorem.paragraph,
        'format' => 'none'
      }
    }

    login user, 'test'
    post '/chists', params

    chist = Chist.find(:title => params['chist']['title'])
    chist.wont_be_nil
    assert_equal false, chist.public
    assert_equal params['chist']['title'], chist.title
    assert_equal params['chist']['chist'], chist.chist
  end

  it 'should edit a chist' do
    user = User.spawn(password: 'test')
    login(user, 'test')
    chist = Chist.create(
      title: Faker::Lorem.sentence(1),
      chist: Faker::Lorem.paragraph,
      chist_raw: Faker::Lorem.paragraph,
      format: 'none',
      user_id: user.id,
      public: true
    )
    chist.wont_be_nil
    new_title = Faker::Name.name

    params = chist.to_hash.merge(title: new_title)
    params.delete(:public)
    params.delete(:id)
    put "/chists/#{chist.id}", {chist: params}

    updated_chist = Chist[chist.id]

    assert_equal new_title, updated_chist.title
    assert_equal false, updated_chist.public
  end

  it 'should delete a chist' do
    user = User.spawn(password: 'test')
    login(user, 'test')

    chist = Chist.create(
      title: Faker::Lorem.sentence(1),
      chist: Faker::Lorem.paragraph,
      chist_raw: Faker::Lorem.paragraph,
      format: 'none',
      public: true,
      user_id: user.id
    )
    chist.wont_be_nil

    delete "/chists/#{chist.id}"

    assert_equal nil, Chist[chist.id]
  end
end
