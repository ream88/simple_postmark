require File.expand_path('../spec_helper', __FILE__)
require 'action_mailer'
require 'rails'
require 'simple_postmark/railtie'

ActionMailer::Base.delivery_method = :simple_postmark

class NotificationMailer < ActionMailer::Base
  default from: 'barney@himym.tld', to: 'ted@himym.tld'

  def im_your_bro
    mail(subject: "I'm your bro!")
  end

  def im_your_bro_tagged
    mail(subject: "I'm your bro!", tag: 'simple-postmark')
  end

  def im_your_bro_multipart
    mail(subject: "I'm your bro!") do |as|
      as.html { render(text: "<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>" )}
      as.text { render(text: "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!" )}
    end
  end

  def the_bro_code
    attachments['thebrocode.jpg'] = File.read(File.join(File.dirname(__FILE__), 'thebrocode.jpg'))
    mail(subject: 'The Brocode!')
  end
end

def merge_body(hash = {})
  Hash[*body.merge(hash).sort.flatten(1)].to_json
end

describe ActionMailer::Base do
  let(:url) { 'http://api.postmarkapp.com/email' }
  let(:api_key) { '********-****-****-****-************' }

  let(:headers) do
    {
      'Accept'                  => 'application/json',
      'ContentType'             => 'application/json',
      'X-Postmark-Server-Token' => api_key
    }
  end

  let(:body) do
    {
      'From'    => 'barney@himym.tld',
      'Subject' => "I'm your bro!",
      'To'      => 'ted@himym.tld'
    }
  end


  before do
    stub_request(:post, url)
  end


  it 'responds to +simple_postmark_settings+' do
    ActionMailer::Base.must_respond_to(:simple_postmark_settings)
  end


  it 'allows setting an api key' do
    ActionMailer::Base.simple_postmark_settings = { api_key: api_key }
    
    ActionMailer::Base.simple_postmark_settings[:api_key].must_equal(api_key)
  end


  describe 'sending mails' do
    before do
      ActionMailer::Base.simple_postmark_settings = { api_key: api_key }
    end


    it 'works' do
      NotificationMailer.im_your_bro.deliver
      
      assert_requested(:post, url, headers: headers, body: merge_body)
    end


    it 'allows tags' do
      NotificationMailer.im_your_bro_tagged.deliver
      
      assert_requested(:post, url, headers: headers, body: merge_body('Tag' => 'simple-postmark'))
    end


    it 'works with attachments' do
      attachment = {
        'Content'     => [File.read(File.join(File.dirname(__FILE__), 'thebrocode.jpg'))].pack('m'),
        'ContentType' => 'image/jpeg',
        'Name'        => 'thebrocode.jpg'
      }
      
      NotificationMailer.the_bro_code.deliver
      
      assert_requested(:post, url, headers: headers, body: merge_body('Subject' => 'The Brocode!', 'Attachments' => [attachment]))
    end


    it 'works with multipart messages' do
      bodies = {
        'HtmlBody' => "<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>",
        'TextBody' => "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!"
      }
      
      NotificationMailer.im_your_bro_multipart.deliver
      
      assert_requested(:post, url, headers: headers, body: merge_body(bodies))
    end
  end
end