require File.expand_path('../../spec_helper', __FILE__)

describe Mail::Message do
  describe 'integration into Mail::Message' do
    subject { Mail::Message.new }


    it 'responds to +to_postmark+' do
      subject.must_respond_to(:to_postmark)
    end
  end


  describe 'integration into Mail' do
    subject { Mail.new }


    it 'responds to +to_postmark+' do
      subject.must_respond_to(:to_postmark)
    end
  end


  describe :to_postmark do
    subject do
      Mail.new do
        from     'barney@himym.tld'
        to       'ted@himym.tld'
        subject  "I'm your bro!"
        body     "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!"
        tag      'simple-postmark'
      end
    end


    it 'returns a hash' do
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
      subject.add_file(File.join(File.dirname(__FILE__), '..', 'thebrocode.jpg'))
      
      subject.to_postmark.must_equal(hash)
    end


    it 'returns multiple recipients as comma-separated list' do
      subject.to = ['barney@himym.tld', 'marshall@himym.tld']
      
      subject.to_postmark['To'].must_equal('barney@himym.tld, marshall@himym.tld')
    end


    it 'returns all email headers as hash' do
      subject.bcc = 'lily@himym.tld'
      subject.cc = 'marshall@himym.tld'
      subject.reply_to = 'barney@barneystinsonblog.com'
      
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
      
      subject.to_postmark.must_equal(hash)
    end


    it 'should use the from and reply-to names as well as the email addresses' do
      subject.to = 'Lily <lily@himym.tld>'
      subject.from = 'Marshall <marshall@himym.tld>'
      subject.reply_to = 'Barney <barney@barneystinsonblog.com>'
      subject.bcc = 'lily@himym.tld'
      subject.cc = 'marshall@himym.tld'
      
      hash = {
        'To'       => 'Lily <lily@himym.tld>',
        'From'     => 'Marshall <marshall@himym.tld>',
        'ReplyTo'  => 'Barney <barney@barneystinsonblog.com>',
        'Bcc'      => 'lily@himym.tld',
        'Cc'       => 'marshall@himym.tld',
        'Subject'  => "I'm your bro!",
        'Tag'      => 'simple-postmark',
        'TextBody' => "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!",
      }
      
      subject.to_postmark.must_equal(hash)
    end
  end
end
