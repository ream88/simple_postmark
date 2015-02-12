require_relative '../test_helper'

class Mail::MessageTest < Minitest::Test
  def test_responds_to_to_postmark
    assert_respond_to Mail::Message.new, :to_postmark
  end
end
