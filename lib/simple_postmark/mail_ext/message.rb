module Mail
  class Message
    def html_body
      html_part.present? ? html_part.to_postmark['Content'] : content_type && content_type.include?('text/html') ? body : nil
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
      %w[attachments bcc cc from html_body reply_to subject tag text_body to].each.with_object({}) do |key, hash|        
        hash[key.camelcase] = case (value = public_send(key).presence or next)
          when AttachmentsList then value.map(&:to_postmark)
          when Array then value.join(', ')
          else value.to_s
        end
      end
    end
  end
end