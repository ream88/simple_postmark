require File.expand_path('../spec_helper', __FILE__)
require 'action_mailer'
require 'rails'
require 'simple_postmark/railtie'

WebMock.allow_net_connect!

class IntegrationMailer < ActionMailer::Base
  default :to => ENV['SIMPLE_POSTMARK_TO'], :from => ENV['SIMPLE_POSTMARK_FROM']

  def text
    'Mail send via Postmark using SimplePostmark'
  end

  def email
    mail(:subject => 'SimplePostmark') do |as|
      as.text { render(:text => text) }
    end
  end

  def email_with_tags
    mail(:subject => 'SimplePostmark with Tags', :tag => 'simple-postmark') do |as|
      as.text { render(:text => text) }
    end
  end

  def email_with_attachments
    attachments['thebrocode.jpg'] = File.read(File.join(File.dirname(__FILE__), 'thebrocode.jpg'))
    
    mail(:subject => 'SimplePostmark with Attachments') do |as|
      as.text { render(:text => text) }
    end
  end

  def email_with_reply_to
    mail(:subject => 'SimplePostmark with Reply To', :reply_to => ENV['SIMPLE_POSTMARK_REPLY_TO']) do |as|
      as.text { render(:text => text) }
    end
  end
end

describe 'SimplePostmark integration' do
  before do
    ActionMailer::Base.simple_postmark_settings = { :api_key => ENV['SIMPLE_POSTMARK_API_KEY'] }
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
end if ENV['SIMPLE_POSTMARK_INTEGRATION_SPEC']