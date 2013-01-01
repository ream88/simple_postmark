require_relative '../spec_helper'

describe 'Mail::Part' do
  describe 'integration into Mail::Part' do
    subject { Mail::Part.new }


    it 'responds to +to_postmark+' do
      subject.must_respond_to(:to_postmark)
    end
  end


  describe :to_postmark do
    describe 'a text/plain part' do
      let(:content) { "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!" }
      subject do
        Mail::Part.new.tap do |mail|
          mail.body = content
          mail.content_type = 'text/plain'
        end
      end


      it 'returns body hash' do
        subject.to_postmark.must_equal('Name' => nil, 'Content' => content, 'ContentType' => 'text/plain')
      end
    end


    describe 'a text/html part' do
      let(:content) { "<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>" }
      subject do
        Mail::Part.new.tap do |mail|
          mail.body = content
          mail.content_type = 'text/html'
        end
      end


      it 'returns body hash' do
        subject.to_postmark.must_equal('Name' => nil, 'Content' => content, 'ContentType' => 'text/html')
      end
    end


    describe 'a file part' do
      let(:file) { File.join(File.dirname(__FILE__), '..', 'thebrocode.jpg') }
      let(:content) { [File.read(file)].pack('m') }
      subject do
        Mail::Part.new.tap do |mail|
          mail.add_file(file)
        end.attachments.first
      end


      it 'returns base64-encoded file-content hash if part is an attachment' do
        subject.to_postmark.must_equal('Name' => 'thebrocode.jpg', 'Content' => content, 'ContentType' => 'image/jpeg')
      end
    end
  end
end