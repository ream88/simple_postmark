$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'minitest/autorun'
require 'minitest/spec'
require 'purdytest'
require 'simple_postmark'
require 'webmock/minitest'
