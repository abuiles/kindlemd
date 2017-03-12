require 'test_helper'

class ChapterTest < Minitest::Test
  def chapters
    [
      {
        position: 324
      },
      {
        position: 328
      },
      {
        position: 887
      },
      {
        position: 105
      },
      {
        position: 639
      }
    ]
  end

  def expected
    [
      {
        position: 105,
        next: 324,
      },
      {
        position: 324,
        next: 328,
        previous: 105
      },
      {
        position: 328,
        next: 639,
        previous: 324
      },
      {
        position: 639,
        next: 887,
        previous: 328
      },
      {
        position: 887,
        previous: 639
      }
    ]
  end

  def test_that_it_normalizes
    assert_equal expected, Kindlemd::Chapter.normalize(chapters)
  end

  def test_that_it_works_with_empty
    assert_equal [], Kindlemd::Chapter.normalize([])
  end

  def test_that_it_works_with_one_element
    assert_equal [{position: 1}], Kindlemd::Chapter.normalize([{position: 1}])
  end
end
