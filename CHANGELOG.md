## 0.5.2 (May 11, 2013)
* Some refactoring.
* Ruby 2.0 support!
* Rails 4.pre support! Thank you @frodsan! :)
* Updated README.md: simple_postmark will die… someday! :(
* Fixed some problems: #8 and #10.

## 0.5.1 (December 21, 2012)

* Prepared for gem-release.

## 0.5.0 (November 14, 2012)

* Updated/fixed specs to work with Postmark's POSTMARK_API_TEST.

## 0.4.4 (November 13, 2012)

* Prefer the mail hash-access method on the instance to the mail instance method, as the hash-access method returns additional useful information
* active_record_deprecated_finders was renamed. Fix that!

## 0.4.3 (June 08, 2012)

* Return the response in the deliver! method
* Be pride!

## 0.4.2 (April 28, 2012)

* SimplePostmark will now raise Postmark API errors if `ActionMailer::Base.raise_delivery_errors` is set.
