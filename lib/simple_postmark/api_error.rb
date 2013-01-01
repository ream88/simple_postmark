module SimplePostmark
  class APIError < StandardError
    def initialize(response)
      super(response.parsed_response['Message'])
    end
  end
end
