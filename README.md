# simple_postmark

SimplePostmark makes it easy to send mails via [Postmark](http://postmarkapp.com)™ using Rails 3's ActionMailer.
SimplePostmark is inspired by [postmark-gem](https://github.com/wildbit/postmark-gem), but unfortunately postmark-gem forced to me to use non-standard Rails calls like `postmark_attachments`. SimplePostmark uses the standard Rails 3's ActionMailer syntax to send your emails via Postmark.

[![Build Status](https://secure.travis-ci.org/haihappen/simple_postmark.png)](http://travis-ci.org/haihappen/simple_postmark)

Tested against Ruby versions `1.9.2`, `1.9.3`, `ruby-head` and Rails versions `3.0.x`, `3.1.x`, `3.2.x`, `master` (upcoming Rails `4.0.0`).

If you are still using Ruby `1.8.7` with Rails 3, you can use the backported version of this gem called [simple_postmark18](https://github.com/haihappen/simple_postmark/tree/ruby18).

## Installation

In your `Gemfile`:

```ruby
group :production do
  gem 'simple_postmark'
  # or on Ruby 1.8.7
  # gem 'simple_postmark18'
end
```

In your `config/environments/production.rb`:

```ruby
config.action_mailer.delivery_method = :simple_postmark
config.action_mailer.simple_postmark_settings = { api_key: '********-****-****-****-************' }
```

## Usage

Just use your standard Rails 3 Mailer:

```ruby
class NotificationMailer < ActionMailer::Base
  def notification
    mail(to: 'ted@himym.tld', from: 'barney@himym.tld', subject: "I'm your bro!") do
      # ...
    end
  end
end
```

And of course you can use standard attachment calls and [Postmark's tags](http://developer.postmarkapp.com/developer-build.html#message-format):

```ruby
class NotificationMailer < ActionMailer::Base
  def notification
    attachments['thebrocode.pdf'] = File.read('thebrocode.pdf')
  
    mail(to: 'ted@himym.tld', from: 'barney@himym.tld', subject: "I'm your bro!", tag: 'with-attachment') do
      # ...
    end
  end
end
```

## Contributing to simple_postmark
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the [issue tracker](https://github.com/haihappen/simple_postmark/issues) to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

(The MIT license)

Copyright (c) 2011-2012 Mario Uher

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.