module Mail
  class SimplePostmark
    def initialize(values)
      self.settings = { api_key: '********-****-****-****-************' }.merge!(values)
    end
    
    attr_accessor :settings
    
    def deliver!(mail)
      headers = {
        'Accept'                  => 'application/json',
        'ContentType'             => 'application/json',
        'X-Postmark-Server-Token' => settings[:api_key].to_s
      }
      body = mail.to_postmark.to_json
    
      Typhoeus::Request.post('http://api.postmarkapp.com/email', headers: headers, body: body)
    end
  end
end