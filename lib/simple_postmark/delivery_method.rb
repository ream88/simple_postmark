module Mail
  class SimplePostmark < Struct.new(:settings)
    include HTTParty

    base_uri 'http://api.postmarkapp.com'
    headers 'Accept' => 'application/json', 'ContentType' => 'application/json'
    delegate :post, :headers, to: self

    def deliver!(mail)
      response = post('/email', headers: headers.merge('X-Postmark-Server-Token' => settings[:api_key].to_s), body: mail.to_postmark.to_json)
      raise ::SimplePostmark::APIError.new(response) unless response.success?
      response
    end
  end
end
