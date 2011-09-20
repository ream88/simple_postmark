require 'spec_helper'
require 'action_mailer'
require 'rails'
require 'simple_postmark/railtie'

ActionMailer::Base.delivery_method = :simple_postmark

class NotificationMailer < ActionMailer::Base
  default from: 'barney.stinson@howimetyourmother.tld', to: 'ted.mosby@howimetyourmother.tld'
  
  def im_your_bro
    mail(subject: "I'm your bro!")
  end
  
  def im_your_bro_tagged
    mail(subject: "I'm your bro!", tag: 'simple-postmark')
  end
  
  def im_your_bro_multipart
    mail(subject: "I'm your bro!") do |as|
      as.html { render(:text => "<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>" )}
      as.text { render(:text => "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!" )}
    end
  end
  
  def the_bro_code
    attachments['thebrocode.jpg'] = File.read(File.join(File.dirname(__FILE__), 'thebrocode.jpg'))
    mail(subject: 'The Brocode!')
  end
end

describe ActionMailer::Base do
  let(:api_key) { [8, 4, 4, 4, 12].collect { |n| n.times.collect { (1..9).to_a.sample }.join }.join('-') }
  
  let(:headers) do 
    {
      'Accept'                  => 'application/json',
      'ContentType'             => 'application/json',
      'User-Agent'              => 'Typhoeus - http://github.com/dbalatero/typhoeus/tree/master',
      'X-Postmark-Server-Token' => api_key
    }
  end
      
  let(:body) do
    {
      'From'    => 'barney.stinson@howimetyourmother.tld',
      'Subject' => "I'm your bro!",
      'To'      => 'ted.mosby@howimetyourmother.tld'
    }
  end
  
  before do
    stub_request(:post, 'http://api.postmarkapp.com/email')
  end
  
  it 'should respond to +simple_postmark_settings+' do
    ActionMailer::Base.must_respond_to(:simple_postmark_settings)
  end
  
  it 'should allow setting an api key' do
    ActionMailer::Base.simple_postmark_settings = { api_key: api_key }
    
    ActionMailer::Base.simple_postmark_settings[:api_key].must_equal(api_key)
  end
  
  describe 'sending mails' do
    before do
      ActionMailer::Base.simple_postmark_settings = { api_key: api_key }
    end
    
    it 'should work' do
      body = Hash[*self.body.sort.flatten].to_json
      
      -> {
        NotificationMailer.im_your_bro.deliver
      }.must_request(:post, 'http://api.postmarkapp.com/email', headers: headers, body: body)
    end
    
    it 'should allow tags' do
      body = Hash[*self.body.merge('Tag' => 'simple-postmark').sort.flatten].to_json
      
      -> {
        NotificationMailer.im_your_bro_tagged.deliver
      }.must_request(:post, 'http://api.postmarkapp.com/email', headers: headers, body: body)
    end

    it 'should work with attachments' do
      attachment = {
        'Content'     => [File.read(File.join(File.dirname(__FILE__), 'thebrocode.jpg'))].pack('m'),
        'ContentType' => 'image/jpeg',
        'Name'        => 'thebrocode.jpg'
      }
      body = Hash[*self.body.merge('Subject' => 'The Brocode!').sort.flatten].merge('Attachments' => [attachment]).to_json
      
      -> {
        NotificationMailer.the_bro_code.deliver
      }.must_request(:post, 'http://api.postmarkapp.com/email', headers: headers, body: body)
    end

    it 'should work with multipart messages' do
      body = {
        'HtmlBody' => "<p>Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome.<br /><br />I'm your bro-I'm Broda!</p>",
        'TextBody' => "Think of me like Yoda, but instead of being little and green I wear suits and I'm awesome. I'm your bro-I'm Broda!"
      }
      body = Hash[*self.body.merge(body).sort.flatten].to_json
      
      -> {
        NotificationMailer.im_your_bro_multipart.deliver
      }.must_request(:post, 'http://api.postmarkapp.com/email', headers: headers, body: body)
    end
  end
end