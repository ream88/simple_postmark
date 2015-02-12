$: << File.expand_path('../lib', __FILE__)
require 'simple_postmark/version'

Gem::Specification.new do |gem|
  gem.name          = 'simple_postmark'
  gem.version       = SimplePostmark::VERSION
  gem.authors       = 'Mario Uher'
  gem.email         = 'uher.mario@gmail.com'
  gem.description   = 'SimplePostmark makes it easy to send mails via Postmark using Rails\'s ActionMailer.'
  gem.summary       = 'A simple way to use Postmark with your Rails app.'
  gem.homepage      = 'http://haihappen.github.com/simple_postmark'

  gem.files         = `git ls-files`.split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'activesupport', '>= 3.0', '< 4.2.0'
  gem.add_dependency 'actionmailer',  '>= 3.0', '< 4.2.0'
  gem.add_dependency 'httparty'
  gem.add_dependency 'json'
  gem.add_dependency 'mail'

  gem.add_development_dependency 'minitest', '>= 4.0', '< 5.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'webmock'
end
