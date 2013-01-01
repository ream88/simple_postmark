require 'active_support/core_ext'
require 'httparty'
require 'json'
require 'mail'

module SimplePostmark
  require 'simple_postmark/mail_ext/message'
  require 'simple_postmark/mail_ext/part'

  require 'simple_postmark/delivery_method'
  require 'simple_postmark/api_error'

  require 'simple_postmark/railtie' if defined?(Rails)
end
