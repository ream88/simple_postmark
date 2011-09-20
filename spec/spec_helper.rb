$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'minitest/spec'
require 'simple_postmark'
require 'webmock/minitest'

class Proc
  def must_request(method, uri, options = {}, &block)
    call
    WebMock::API.assert_requested(method, uri, options, &block)
  end
end