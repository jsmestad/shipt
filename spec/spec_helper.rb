# TODO (DC 2010-07-04) This next line is necessary when running 'rake spec'.
# Why doesn't the rspec-core ref in Gemfile handle this.
require 'rspec/core'
require 'autotest/rspec2'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'shipt'

Dir['./spec/support/**/*.rb'].map {|f| require f}

RSpec.configure do |c|
  
end