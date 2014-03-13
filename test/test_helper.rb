require 'minitest/spec'
require 'minitest/autorun'
require 'pp'
require 'faker'
require 'spawn'
require 'rack/test'

ENV["RACK_ENV"]  = "test"

require File.dirname(__FILE__) + '/../app'

require File.dirname(__FILE__) + '/spawners'

class MiniTest::Spec
  include Rack::Test::Methods

  def app
    Cuba.app
  end
end

OmniAuth.config.test_mode = true
