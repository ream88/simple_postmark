require_relative '../test_helper'


class IntegrationTest < Minitest::Test
  URL = 'http://api.postmarkapp.com/email'
  API_KEY = '********-****-****-****-************'

  HEADERS = {
    'Accept'                  => 'application/json',
    'ContentType'             => 'application/json',
    'X-Postmark-Server-Token' => API_KEY
  }

  BODY = {
    'From'     => 'barney@himym.tld',
    'Subject'  => %{I'm your bro!},
    'TextBody' => %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!},
    'To'       => 'ted@himym.tld'
  }


  def setup
    ActionMailer::Base.add_delivery_method :simple_postmark, Mail::SimplePostmark, api_key: nil
    ActionMailer::Base.delivery_method = :simple_postmark
    ActionMailer::Base.simple_postmark_settings = { api_key: API_KEY, return_response: true }
    ActionMailer::Base.raise_delivery_errors = true

    WebMock.enable!
  end


  def test_responds_to_simple_postmark_settings
    assert_respond_to ActionMailer::Base, :simple_postmark_settings
  end


  def test_set_api_key
    assert_equal API_KEY, ActionMailer::Base.simple_postmark_settings.fetch(:api_key)
  end


  def test_send_email
    stub_request :post, URL
    TestMailer.email.deliver_now

    assert_requested :post, URL, headers: HEADERS, body: BODY.to_json
  end


  def test_send_email_with_tags
    stub_request :post, URL
    TestMailer.email_with_tags.deliver_now

    assert_requested :post, URL, headers: HEADERS, body: Hash[BODY.merge('Tag' => 'simple-postmark').sort].to_json
  end


  def test_send_email_with_attachments
    attachment = {
      'Content'     => [BROCODE].pack('m'),
      'ContentType' => 'image/jpeg',
      'Name'        => 'thebrocode.jpg'
    }

    stub_request :post, URL
    TestMailer.email_with_attachments.deliver_now

    assert_requested :post, URL, headers: HEADERS, body: Hash[BODY.merge('Subject' => %{The Brocode!}, 'Attachments' => [attachment]).sort].to_json
  end


  def test_send_email_with_multipart
    multipart = {
      'HtmlBody' => %{<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>},
      'TextBody' => %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!}
    }

    stub_request :post, URL
    TestMailer.email_with_multipart.deliver_now

    assert_requested :post, URL, headers: HEADERS, body: Hash[BODY.merge(multipart).sort].to_json
  end


  def teardown
    ActionMailer::Base.delivery_method = :test

    WebMock.disable!
  end
end

