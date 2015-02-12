require_relative 'test_helper'

class SimplePostmarkTest < MiniTest::Unit::TestCase
  def test_responds_to_deliver!
    assert_respond_to Mail::SimplePostmark.new, :deliver!
  end


  def test_makes_request
    WebMock.enable!

    url = 'http://api.postmarkapp.com/email'

    mail = Mail.new do
      from     'barney@himym.tld'
      to       'ted@himym.tld'
      subject  %{I'm your bro!}
      body     %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!}
      tag      'simple-postmark'
      add_file BROCODE
    end

    mail.delivery_method Mail::SimplePostmark
    stub_request :post, url
    mail.deliver

    assert_requested :post, url, headers: { 'Accept' => 'application/json', 'ContentType' => 'application/json', 'X-Postmark-Server-Token' => '' }

    WebMock.disable!
  end
end
