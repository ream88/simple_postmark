require File.expand_path('../spec_helper', __FILE__)

describe Mail do
  describe SimplePostmark do
    let(:instance) { Mail::SimplePostmark.new({}) }
    
    it 'should respond to deliver!' do
      instance.must_respond_to(:deliver!)
    end
    
    describe :deliver! do
      let(:mail) do
        Mail.new do
          from     'barney.stinson@howimetyourmother.tld'
          to       'ted.mosby@howimetyourmother.tld'
          subject  "I'm your bro!"
          body     "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!"
          tag      'simple-postmark'
          add_file(File.join(File.dirname(__FILE__), 'thebrocode.jpg'))
        end
      end
      
      before do
        mail.delivery_method(Mail::SimplePostmark)
        stub_request(:post, 'http://api.postmarkapp.com/email')
      end
      
      it 'should send emails' do
        -> {
          mail.deliver
        }.must_request(:post, 'http://api.postmarkapp.com/email')
      end
      
      it 'should post appropriate data' do
        -> {
          mail.deliver
        }.must_request(:post, 'http://api.postmarkapp.com/email', headers: { 'Accept' => 'application/json', 'ContentType' => 'application/json', 'X-Postmark-Server-Token' => '********-****-****-****-************' })
      end
    end
  end
end