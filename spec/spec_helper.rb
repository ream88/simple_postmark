$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'simple_postmark'
require 'webmock/minitest'
