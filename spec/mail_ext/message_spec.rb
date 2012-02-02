require File.expand_path('../../spec_helper', __FILE__)

describe Mail::Message do
  it 'should respond to +to_postmark+' do
    Mail::Message.new.must_respond_to(:to_postmark)
  end


  it 'should respond to +to_postmark+' do
    Mail.new.must_respond_to(:to_postmark)
  end


  describe :to_postmark do
    let(:mail) do
      Mail.new do
        from     'barney@himym.tld'
        to       'ted@himym.tld'
        subject  "I'm your bro!"
        body     "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!"
        tag      'simple-postmark'
      end
    end


    it 'should return a hash' do
      hash = {
        'From'        => 'barney@himym.tld',
        'To'          => 'ted@himym.tld',
        'Subject'     => "I'm your bro!",
        'TextBody'    => "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!",
        'Tag'         => 'simple-postmark',
        'Attachments' => [{
          'Name'        => 'thebrocode.jpg',
          'Content'     => [File.read(File.join(File.dirname(__FILE__), '..', 'thebrocode.jpg'))].pack('m'),
          'ContentType' => 'image/jpeg'
        }]
      }
      mail.add_file(File.join(File.dirname(__FILE__), '..', 'thebrocode.jpg'))
      
      mail.to_postmark.must_equal(hash)
    end


    it 'should return multiple recipients as comma-separated list' do
      mail.to = ['barney@himym.tld', 'marshall@himym.tld']
      
      mail.to_postmark['To'].must_equal('barney@himym.tld, marshall@himym.tld')
    end


    it 'should return all email headers as hash' do
      mail.bcc = 'lily@himym.tld'
      mail.cc = 'marshall@himym.tld'
      mail.reply_to = 'barney@barneystinsonblog.com'
      
      hash = {
        'Bcc'      => 'lily@himym.tld',
        'Cc'       => 'marshall@himym.tld',
        'From'     => 'barney@himym.tld',
        'ReplyTo'  => 'barney@barneystinsonblog.com',
        'Subject'  => "I'm your bro!",
        'Tag'      => 'simple-postmark',
        'TextBody' => "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!",
        'To'       => 'ted@himym.tld'
      }
      
      mail.to_postmark.must_equal(hash)
    end
  end
end