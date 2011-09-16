API_KEY = '********-****-****-****-************'

require 'json'
require 'mail'
require 'typhoeus'

module Mail
  class Part
    def to_postmark
      {}.tap do |hash|
        hash['Name'] = filename
        hash['Content'] = attachment? ? [read].pack('m') : body
        hash['ContentType'] = mime_type
      end
    end
  end
  
  class Message
    def tag(value = nil)
      if value.present?
        self['TAG'] = value
      else
        self['TAG']
      end
    end
    
    def tag=(value)
      self['TAG'] = value
    end
    
    def to_postmark
      {}.tap do |hash|
        %w[bcc cc from reply_to subject tag to].each do |key|
          value = send(key).presence or next
          key = key.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } # CamelCase key
          
          hash[key] = value.respond_to?(:join) ? value.join(', ') : value
        end
        
        hash['TextBody'] = text_part.to_postmark['Content'] if text_part
        hash['HtmlBody'] = html_part.to_postmark['Content'] if html_part
        hash['Attachments'] = attachments.collect(&:to_postmark)
      end
    end
  end
  
  class SimplePostmark
    def deliver!(mail)
      headers = {
        'Accept' => 'application/json',
        'ContentType' => 'application/json',
        'X-Postmark-Server-Token' => ::API_KEY
      }
      body = mail.to_postmark.to_json
      
      Typhoeus::Request.post('http://api.postmarkapp.com/email', headers: headers, body: body)
    end
  end
end


mail = Mail.new do
  from     'me@test.lindsaar.net'
  to       'you@test.lindsaar.net'
  subject  'Here is the image you wanted'
  body     'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
  tag      'simple-postmark'
  add_file :filename => 'somefile.png', :content => File.read('somefile.png')
end

mail.delivery_method(Mail::SimplePostmark)
mail.deliver