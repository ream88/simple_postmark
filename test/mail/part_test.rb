require_relative '../test_helper'

class Mail::PartTest < Minitest::Test
  def test_responds_to_to_postmark
    assert_respond_to Mail::Part.new, :to_postmark
  end


  def test_to_postmark_text_part
    content = %{Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!}

    part = Mail::Part.new
    part.body = content
    part.content_type = 'text/plain'

    assert_equal Hash['Name' => nil, 'Content' => content, 'ContentType' => 'text/plain'], part.to_postmark
  end


  def test_to_postmark_mail_part
    content = %{<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>}

    part = Mail::Part.new
    part.body = content
    part.content_type = 'text/html'

    assert_equal Hash['Name' => nil, 'Content' => content, 'ContentType' => 'text/html'], part.to_postmark
  end


  def test_to_postmark_file_part
    part = Mail::Part.new
    part.add_file BROCODE
    attachment = part.attachments.first

    assert_equal Hash['Name' => 'thebrocode.jpg', 'Content' => [File.read(BROCODE)].pack('m'), 'ContentType' => 'image/jpeg'], attachment.to_postmark
  end
end
