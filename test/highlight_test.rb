require 'test_helper'
require 'minitest/mock'

class HighlightTest < Minitest::Test
  def test_that_it_calls_highlights_for
    @kindle = MiniTest::Mock.new

    @kindle.expect(:highlights_for, [{"asin": "87653"}], [123])

    highglights = Kindlemd::Highlight.fetch(@kindle, 123)
    assert_equal true, @kindle.verify
    assert_equal "87653", highglights[0].asin
  end

  def test_that_it_convert_to_md
    highlight = Kindlemd::Highlight.new({highlight: 'hola', startLocation: 10})
    assert_equal "> hola", highlight.to_markdown
  end
end
