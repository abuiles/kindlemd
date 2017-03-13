require 'test_helper'
require 'minitest/mock'

class HighlightTest < Minitest::Test
  def test_that_it_calls_highlights_for
    @kindle = MiniTest::Mock.new

    @kindle.expect(:highlights_for, [{ asin: '87653' }], [123])

    highglights = Kindlemd::Highlight.fetch(@kindle, 123)
    assert_equal true, @kindle.verify
    assert_equal '87653', highglights[0].asin
  end

  def test_that_it_convert_to_md
    highlight = Kindlemd::Highlight.new(highlight: 'hola', startLocation: 1500)
    assert_equal "---\n\n> hola\n\n---\n[Read more at location 10](kindle://book?action=open&asin=&location=10)", highlight.to_md
  end
end
