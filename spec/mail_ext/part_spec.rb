require File.expand_path('../../spec_helper', __FILE__)

describe Mail::Part do
  it 'should respond to +to_postmark+' do
    Mail::Part.new.must_respond_to(:to_postmark)
  end
  
  describe :to_postmark do
    it 'should return body hash if part is not an attachment' do
      part = Mail::Part.new do
        body         "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!"
        content_type 'text/plain'
      end
      
      content = "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!"
      
      part.to_postmark.must_equal({ 'Name' => nil, 'Content' => content, 'ContentType' => 'text/plain' })
    end
    
    it 'should return body hash if part is not an attachment' do
      part = Mail::Part.new do
        body         "<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>"
        content_type 'text/html'
      end
      
      content = "<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>"
      
      part.to_postmark.must_equal({ 'Name' => nil, 'Content' => content, 'ContentType' => 'text/html' })
    end
    
    
    it 'should return base64-encoded file-content hash if part is an attachment' do
      file = File.join(File.dirname(__FILE__), '..', 'thebrocode.jpg')
      
      part = Mail::Part.new.tap do |mail|
        mail.add_file(file)
      end.attachments.first
        
      content = [File.read(file)].pack('m')
      
      part.to_postmark.must_equal({ 'Name' => 'thebrocode.jpg', 'Content' => content, 'ContentType' => 'image/jpeg' })
    end
  end
end