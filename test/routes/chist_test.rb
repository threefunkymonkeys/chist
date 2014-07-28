require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe ChistApp::Chists do
  def setup
    Chist.all.each { |chist| chist.delete }
  end

  it 'should create public chist (201)' do
    params = {
      'chist' => {
        'title' => Faker::Lorem.sentence(1),
        'chist' => Faker::Lorem.paragraph,
        'format' => 'none',
        'public' => "true"
      }
    }
    post '/chists', params

    chist = Chist.find(:title => params['chist']['title'])
    chist.wont_be_nil
    assert_equal true, chist.public
    assert_equal params['chist']['title'], chist.title
    assert_equal params['chist']['chist'], chist.chist
  end

  it 'should create private chist (201)' do
    params = {
      'chist' => {
        'title' => Faker::Lorem.sentence(1),
        'chist' => Faker::Lorem.paragraph,
        'format' => 'none'
      }
    }
    post '/chists', params

    chist = Chist.find(:title => params['chist']['title'])
    chist.wont_be_nil
    assert_equal false, chist.public
    assert_equal params['chist']['title'], chist.title
    assert_equal params['chist']['chist'], chist.chist
  end

  it 'should edit a chist' do
    chist = Chist.create(
      title: Faker::Lorem.sentence(1),
      chist: Faker::Lorem.paragraph,
      chist_raw: Faker::Lorem.paragraph,
      format: 'none',
      public: true
    )
    chist.wont_be_nil
    new_title = Faker::Name.name

    put "/chists/#{chist.id}/edit", {:'chist' => {:'title' => new_title, :'public' => false}}

    updated_chist = Chist[chist.id]

    assert_equal new_title, updated_chist.title
    assert_equal false, updated_chist.public
  end

  it 'should delete a chist' do
    chist = Chist.create(
      title: Faker::Lorem.sentence(1),
      chist: Faker::Lorem.paragraph,
      chist_raw: Faker::Lorem.paragraph,
      format: 'none',
      public: true
    )
    chist.wont_be_nil

    delete "/chists/#{chist.id}"

    assert_equal nil, Chist[chist.id]
  end
end
