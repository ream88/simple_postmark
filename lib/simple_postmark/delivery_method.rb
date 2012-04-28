module Mail
  class SimplePostmark
    include HTTParty

    def initialize(values)
      self.settings = { api_key: '********-****-****-****-************' }.merge(values)
    end

    attr_accessor :settings
    base_uri 'http://api.postmarkapp.com'
    headers 'Accept' => 'application/json', 'ContentType' => 'application/json'

    def deliver!(mail)
      api_key = { 'X-Postmark-Server-Token' => settings[:api_key].to_s }
      
      response = self.class.post('/email', headers: self.class.headers.merge(api_key), body: mail.to_postmark.to_json)
      raise ::SimplePostmark::APIError.new(response) unless response.success?
    end
  end
end