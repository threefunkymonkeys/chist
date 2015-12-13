require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe ChistApp::Dashboard do

  def setup
    Contact.dataset.truncate
  end

  it 'should show contact page' do
    get '/contact'

    assert_equal 200, last_response.status
  end

  it 'should create conctact message' do
    user = User.spawn(password: 'qwe123')
    login(user, 'qwe123')

    params = {
      :contact => {
        :name => "Ed Vedder",
        :email => "ed@example.com",
        :message => "Test Message",
        :sample => "Some code"
      }
    }

    post "/contact", params

    contact = Contact.first

    assert_equal 302, last_response.status
    assert_equal 1, Contact.count
    assert_equal params[:contact][:name], contact.name
    assert_equal params[:contact][:email], contact.email
    assert_equal params[:contact][:message], contact.message
    assert_equal params[:contact][:sample], contact.sample
  end
end
