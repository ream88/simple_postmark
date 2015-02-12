require_relative '../test_helper'

class Mail::MessageTest < MiniTest::Unit::TestCase
  def test_responds_to_to_postmark
    assert_respond_to Mail::Message.new, :to_postmark
  end
end
