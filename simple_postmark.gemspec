Gem::Specification.new do |gem|
  gem.name          = 'simple_postmark'
  gem.version       = '0.4.0'
  gem.authors       = 'Mario Uher'
  gem.email         = 'uher.mario@gmail.com'
  gem.description   = 'SimplePostmark makes it easy to send mails via Postmark™ using Rails 3\'s ActionMailer.'
  gem.summary       = 'A simple way to use Postmark™ with your Rails app.'
  gem.homepage      = 'http://haihappen.github.com/simple_postmark'

  gem.files         = `git ls-files`.split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'activesupport', '~> 3.0'
  gem.add_dependency 'httparty'
  gem.add_dependency 'json'
  gem.add_dependency 'mail'

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'purdytest'
  gem.add_development_dependency 'rails', '~> 3.0'
  gem.add_development_dependency 'webmock'
end
