class TestMailer < ActionMailer::Base
  default from: 'barney@himym.tld', to: 'ted@himym.tld'

  def text
    %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!}
  end

  def email
    mail subject: %{I'm your bro!} do |as|
      as.text { render text: text }
    end
  end

  def email_with_tags
    mail subject: %{I'm your bro!}, tag: 'simple-postmark' do |as|
      as.text { render text: text }
    end
  end

  def email_with_attachments
    attachments['thebrocode.jpg'] = BROCODE

    mail subject: %{The Brocode!} do |as|
      as.text { render text: text }
    end
  end

  def email_with_reply_to
    mail subject: %{I'm your bro!}, reply_to: 'barney@barneystinsonblog.com' do |as|
      as.text { render text: text }
    end
  end


  def email_with_multipart
    mail subject: %{I'm your bro!} do |as|
      as.text { render text: %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!} }
      as.html { render text: %{<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>} }
    end
  end
end
