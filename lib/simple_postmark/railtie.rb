module SimplePostmark
  class Railtie < ::Rails::Railtie
    ActionMailer::Base.add_delivery_method(:simple_postmark, Mail::SimplePostmark, api_key: nil)
  end
end