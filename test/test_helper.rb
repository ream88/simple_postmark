$: << File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'

require 'action_mailer'
require 'simple_postmark'

require_relative 'test_mailer'

BROCODE = File.join(File.dirname(__FILE__), 'thebrocode.jpg')
