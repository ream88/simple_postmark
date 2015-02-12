require_relative 'test_helper'

class MailTest < MiniTest::Unit::TestCase
  def test_responds_to_to_postmark
    assert_respond_to Mail.new, :to_postmark
  end


  def build_mail
    Mail.new do
      from     'barney@himym.tld'
      to       'ted@himym.tld'
      subject  %{I'm your bro!}
      body     %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!}
      tag      'simple-postmark'
    end
  end


  def test_to_postmark_returns_a_hash
    hash = {
      'From'        => 'barney@himym.tld',
      'To'          => 'ted@himym.tld',
      'Subject'     => %{I'm your bro!},
      'TextBody'    => %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!},
      'Tag'         => 'simple-postmark',
      'Attachments' => [{
        'Name'        => 'thebrocode.jpg',
        'Content'     => [File.read(BROCODE)].pack('m'),
        'ContentType' => 'image/jpeg'
      }]
    }

    mail = build_mail
    mail.add_file BROCODE

    assert_equal hash, mail.to_postmark
  end


  def test_multiple_recipients
    mail = build_mail
    mail.to = ['barney@himym.tld', 'marshall@himym.tld']

    assert_equal 'barney@himym.tld, marshall@himym.tld', mail.to_postmark.fetch('To')
  end


  def test_email_headers
    hash = {
      'Bcc'      => 'lily@himym.tld',
      'Cc'       => 'marshall@himym.tld',
      'From'     => 'barney@himym.tld',
      'ReplyTo'  => 'barney@barneystinsonblog.com',
      'Subject'  => %{I'm your bro!},
      'Tag'      => 'simple-postmark',
      'TextBody' => %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!},
      'To'       => 'ted@himym.tld'
    }

    mail = build_mail
    mail.bcc = 'lily@himym.tld'
    mail.cc = 'marshall@himym.tld'
    mail.reply_to = 'barney@barneystinsonblog.com'

    assert_equal hash, mail.to_postmark
  end


  def test_from_and_reply_to
    hash = {
      'To'       => 'Lily <lily@himym.tld>',
      'From'     => 'Marshall <marshall@himym.tld>',
      'ReplyTo'  => 'Barney <barney@barneystinsonblog.com>',
      'Bcc'      => 'lily@himym.tld',
      'Cc'       => 'marshall@himym.tld',
      'Subject'  => %{I'm your bro!},
      'Tag'      => 'simple-postmark',
      'TextBody' => %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!},
    }

    mail = build_mail
    mail.to = 'Lily <lily@himym.tld>'
    mail.from = 'Marshall <marshall@himym.tld>'
    mail.reply_to = 'Barney <barney@barneystinsonblog.com>'
    mail.bcc = 'lily@himym.tld'
    mail.cc = 'marshall@himym.tld'

    assert_equal hash, mail.to_postmark
  end
end

