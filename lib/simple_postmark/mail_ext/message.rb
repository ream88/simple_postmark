module Mail
  class Message
    def html_body
      if html_part.present?
        html_part.to_postmark['Content']
      else
        body if content_type.to_s.include?('text/html')
      end
    end

    def tag(val = nil)
      default(:tag, val)
    end

    def tag=(val)
      header[:tag] = val
    end

    def text_body
      text_part.present? ? text_part.to_postmark['Content'] : body
    end

    def to_postmark
      hash = {}
      
      %w[attachments bcc cc from html_body reply_to subject tag text_body to].each do |key|
        hash[key.camelcase] = case (value = send(key).presence or next)
          when AttachmentsList then value.map(&:to_postmark)
          when Array then value.join(', ')
          else value.to_s
        end
      end
      
      hash
    end
  end
end