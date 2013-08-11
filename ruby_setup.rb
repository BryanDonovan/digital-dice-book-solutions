require 'pp'
require 'minitest/spec'
require 'minitest/autorun'

begin
  require 'turn/autorun'
rescue
  # Use default minitest reporter.
end
