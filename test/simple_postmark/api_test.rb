require_relative '../test_helper'


class SimplePostmark::APITest < Minitest::Test
  def setup
    ActionMailer::Base.add_delivery_method :simple_postmark, Mail::SimplePostmark, api_key: nil
    ActionMailer::Base.delivery_method = :simple_postmark
    ActionMailer::Base.simple_postmark_settings = { api_key: 'POSTMARK_API_TEST', return_response: true }
    ActionMailer::Base.raise_delivery_errors = true

    WebMock.disable!
  end


  def test_send_email
    TestMailer.email.deliver_now
  end


  def test_send_email_with_tags
    TestMailer.email_with_tags.deliver_now
  end


  def test_send_email_with_attachments
    TestMailer.email_with_attachments.deliver_now
  end


  def test_send_email_with_reply_to
    TestMailer.email_with_reply_to.deliver_now
  end


  def test_fails_using_wrong_settings
    ActionMailer::Base.simple_postmark_settings = { api_key: '********-****-****-****-************', return_response: true }

    assert_raises SimplePostmark::APIError do
      TestMailer.email.deliver_now
    end
  end


  def test_can_be_silent
    ActionMailer::Base.simple_postmark_settings = { api_key: '********-****-****-****-************', return_response: true }

    ActionMailer::Base.raise_delivery_errors = false

    TestMailer.email.deliver_now
  end


  def test_parsed_response
    response = TestMailer.email.deliver_now!.parsed_response

    assert_equal 'ted@himym.tld', response.fetch('To')
    assert_equal 'Test job accepted', response.fetch('Message')
    assert response.fetch('MessageID')
  end


  def teardown
    WebMock.enable!

    ActionMailer::Base.delivery_method = :test
  end
end

