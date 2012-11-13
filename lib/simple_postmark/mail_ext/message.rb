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
      %w[attachments bcc cc from html_body reply_to subject tag text_body to].each.with_object({}) do |key, hash|
        # mail returns different responses for mail[:reply_to] than mail.reply_to, and we want to prefer the former
        # as it includes the name, not just the email
        key_value = self[key.to_sym].nil? ? public_send(key) : self[key.to_sym]
        hash[key.camelcase] = case (value = key_value.presence or next)
          when AttachmentsList then value.map(&:to_postmark)
          when Array then value.join(', ')
          else value.to_s
        end
      end
    end
  end
end
