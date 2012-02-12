# encoding: utf-8
require './lib/simple_postmark/version'

Gem::Specification.new do |s|
  s.name         = 'simple_postmark18'
  s.version      = SimplePostmark::VERSION
  s.author       = 'Mario Uher'
  s.email        = 'uher.mario@gmail.com'
  s.homepage     = 'https://www.github.com/haihappen/simple_postmark'
  s.summary      = 'A simple way to use Postmark™ with your Rails app.'
  s.description  = 'SimplePostmark makes it easy to send mails via Postmark™ using Rails 3\'s ActionMailer.'

  s.files        = Dir.glob('lib/**/*')
  s.require_path = 'lib'

  s.add_dependency('activesupport', '~> 3.0')
  s.add_dependency('httparty')
  s.add_dependency('json')
  s.add_dependency('mail')

  s.add_development_dependency('minitest')
  s.add_development_dependency('purdytest')
  s.add_development_dependency('rails', '~> 3.0')
  s.add_development_dependency('webmock')
end