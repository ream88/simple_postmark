module Mail
  class SimplePostmark < Struct.new(:settings)
    include HTTParty

    base_uri 'http://api.postmarkapp.com'
    headers 'Accept' => 'application/json', 'ContentType' => 'application/json'

    def deliver!(mail)
      response = self.class.post('/email', headers: headers, body: get_body(mail))
      raise ::SimplePostmark::APIError.new(response) unless response.success?
      response
    end

  private
    def headers
      self.class.headers.merge('X-Postmark-Server-Token' => settings[:api_key].to_s)
    end

    def get_body(mail)
      mail.to_postmark.to_json
    end
  end
end
