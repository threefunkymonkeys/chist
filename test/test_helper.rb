require 'minitest/spec'
require 'minitest/autorun'
require 'pp'
require 'faker'
require 'spawn'

ENV["RACK_ENV"]  = "test"

require File.dirname(__FILE__) + '/../app'

require File.dirname(__FILE__) + '/spawners'
