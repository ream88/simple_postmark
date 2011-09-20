module Mail
  class Message
    def tag(val = nil)
      default(:tag, val)
    end

    def tag=(val)
      header[:tag] = val
    end

    def to_postmark
      {}.tap do |hash|
        %w[bcc cc from html_body reply_to subject tag text_body to].each do |key|
          value = send(key).presence or next
          hash[key.camelcase] = value.respond_to?(:join) ? value.join(', ') : value.to_s
        end
        hash['Attachments'] = attachments.map(&:to_postmark) if has_attachments?
      end
    end
    
    private
    def html_body
      html_part.present? ? html_part.to_postmark['Content'] : content_type && content_type.include?('text/html') ? body : nil
    end

    def text_body
      text_part.present? ? text_part.to_postmark['Content'] : body
    end
  end
end