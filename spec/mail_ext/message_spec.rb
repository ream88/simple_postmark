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
        from     'barney.stinson@howimetyourmother.tld'
        to       'ted.mosby@howimetyourmother.tld'
        subject  "I'm your bro!"
        body     "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!"
        tag      'simple-postmark'
      end
    end
    
    it 'should return a hash' do
      hash = {
        'From'        => 'barney.stinson@howimetyourmother.tld',
        'To'          => 'ted.mosby@howimetyourmother.tld',
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
      mail.to = ['barney.stinson@howimetyourmother.tld', 'marshall.eriksen@howimetyourmother.tld']
      
      mail.to_postmark['To'].must_equal('barney.stinson@howimetyourmother.tld, marshall.eriksen@howimetyourmother.tld')
    end
    
    it 'should return all email headers as hash' do
      mail.bcc = 'lily.aldrin@howimetyourmother.tld'
      mail.cc = 'marshall.eriksen@howimetyourmother.tld'
      mail.reply_to = 'barney.stinson@barneystinsonblog.com'
      
      hash = {
        'Bcc'      => 'lily.aldrin@howimetyourmother.tld',
        'Cc'       => 'marshall.eriksen@howimetyourmother.tld',
        'From'     => 'barney.stinson@howimetyourmother.tld',
        'ReplyTo'  => 'barney.stinson@barneystinsonblog.com',
        'Subject'  => "I'm your bro!",
        'Tag'      => 'simple-postmark',
        'TextBody' => "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!",
        'To'       => 'ted.mosby@howimetyourmother.tld'
      }
      
      mail.to_postmark.must_equal(hash)
    end
  end
end