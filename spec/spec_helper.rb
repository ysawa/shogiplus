# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../config/mongoid'
require File.dirname(__FILE__) + '/../lib/shogi'
require File.dirname(__FILE__) + '/../lib/facebook'
require 'pp'
require 'fakeweb'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end
