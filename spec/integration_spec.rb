require File.expand_path('../spec_helper', __FILE__)
require 'action_mailer'
require 'rails'
require 'simple_postmark/railtie'

WebMock.allow_net_connect!

class IntegrationMailer < ActionMailer::Base
  default to: ENV['SIMPLE_POSTMARK_TO'], from: ENV['SIMPLE_POSTMARK_FROM']

  def text
    'Mail send via Postmark using SimplePostmark'
  end

  def email
    mail(subject: 'SimplePostmark') do |as|
      as.text { render(text: text) }
    end
  end

  def email_with_tags
    mail(subject: 'SimplePostmark with Tags', tag: 'simple-postmark') do |as|
      as.text { render(text: text) }
    end
  end

  def email_with_attachments
    attachments['thebrocode.jpg'] = File.read(File.join(File.dirname(__FILE__), 'thebrocode.jpg'))
    
    mail(subject: 'SimplePostmark with Attachments') do |as|
      as.text { render(text: text) }
    end
  end

  def email_with_reply_to
    mail(subject: 'SimplePostmark with Reply To', reply_to: ENV['SIMPLE_POSTMARK_REPLY_TO']) do |as|
      as.text { render(text: text) }
    end
  end
end

describe 'SimplePostmark integration' do
  before do
    ActionMailer::Base.simple_postmark_settings = { api_key: ENV['SIMPLE_POSTMARK_API_KEY'], return_response: true }
    ActionMailer::Base.raise_delivery_errors = true
  end


  it 'sends emails' do
    IntegrationMailer.email.deliver
  end


  it 'sends emails with tags' do
    IntegrationMailer.email_with_tags.deliver
  end


  it 'sends emails with attachments' do
    IntegrationMailer.email_with_attachments.deliver
  end


  it 'sends emails with reply-to' do
    IntegrationMailer.email_with_reply_to.deliver
  end


  describe 'wrong mail settings' do
    before do
      ActionMailer::Base.simple_postmark_settings = { api_key: '********-****-****-****-************' }
    end


    it 'is silent if raise_delivery_errors is not set' do
      ActionMailer::Base.raise_delivery_errors = false
      
      IntegrationMailer.email.deliver
    end


    it 'raises a SimplePostmark::APIError containing the error from postmarkapp.com if raise_delivery_errors is set' do
      -> { IntegrationMailer.email.deliver }.must_raise(SimplePostmark::APIError)
    end
  end


  describe 'setting return_response option' do
    before do
      ActionMailer::Base.simple_postmark_settings = { api_key: ENV['SIMPLE_POSTMARK_API_KEY'], return_response: true }
    end


    it 'returns the response from postmarkapp.com' do
      response = IntegrationMailer.email.deliver!.parsed_response
      
      response['To'].must_equal(ENV['SIMPLE_POSTMARK_TO'])
      response['Message'].must_equal('OK')
    end
  end
end if ENV['SIMPLE_POSTMARK_INTEGRATION_SPEC']
