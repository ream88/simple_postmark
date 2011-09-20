module Mail
  class Part
    def to_postmark
      {}.tap do |hash|
        hash['Content'] = attachment? ? [read].pack('m') : body.to_s
        hash['ContentType'] = mime_type
        hash['Name'] = filename
      end
    end
  end
end