require 'test_helper'

class ChapterTest < Minitest::Test
  def chapters
    [
      {
        location: 324
      },
      {
        location: 328
      },
      {
        location: 887
      },
      {
        location: 105
      },
      {
        location: 639
      }
    ]
  end

  def expected
    [
      {
        location: 105,
        next_chapter: 324
      },
      {
        location: 324,
        next_chapter: 328,
        previous: 105
      },
      {
        location: 328,
        next_chapter: 639,
        previous: 324
      },
      {
        location: 639,
        next_chapter: 887,
        previous: 328
      },
      {
        location: 887,
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
    assert_equal [{ location: 1 }], Kindlemd::Chapter.normalize([{ location: 1 }])
  end

  def test_that_it_owns_highlights
    chapter = Kindlemd::Chapter.new(
      location: 1,
      next_chapter: 20
    )

    highlight = Kindlemd::Highlight.new(startLocation: 1500)
    assert_equal true, chapter.owns?(highlight)

    highlight = Kindlemd::Highlight.new(startLocation: 3150)
    assert_equal false, chapter.owns?(highlight)

    highlight = Kindlemd::Highlight.new(startLocation: 22500)
    assert_equal false, chapter.owns?(highlight)
  end

  def test_that_it_adds_highlights
    chapter = Kindlemd::Chapter.new(
      location: 1,
      next_chapter: 20
    )

    highlight = Kindlemd::Highlight.new(startLocation: 1500)
    chapter.add_highlight(highlight)

    assert_equal chapter, highlight.chapter

    highlight = Kindlemd::Highlight.new(startLocation: 3150)
    chapter.add_highlight(highlight)

    assert_nil highlight.chapter

    highlight = Kindlemd::Highlight.new(startLocation: 22500)
    chapter.add_highlight(highlight)

    assert_nil highlight.chapter
  end

  def test_that_it_converts_to_md
    chapter = Kindlemd::Chapter.new(
      name: 'foo',
      location: 1,
      next_chapter: 20
    )

    highlight = Kindlemd::Highlight.new(
      highlight: 'hola',
      startLocation: 1500
    )
    chapter.add_highlight(highlight)

    highlight = Kindlemd::Highlight.new(
      highlight: 'mundo',
      startLocation: 1650
    )

    chapter.add_highlight(highlight)

    expected = [
      "## **foo**",
      "---\n\n> hola\n\n---\n[Read more at location 10](kindle://book?action=open&asin=&location=10)",
      "---\n\n> mundo\n\n---\n[Read more at location 11](kindle://book?action=open&asin=&location=11)"
    ]

    assert_equal expected, chapter.to_md
  end
end
