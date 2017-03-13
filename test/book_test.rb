require 'test_helper'

class BookTest < Minitest::Test
  def chapters
    [
      {
        name: 'The promise of Behavioral Design',
        location: 105
      },
      {
        name: 'Part One: The problem',
        location: 324
      },
      {
        name: '1. Unconsious Bias is everywhere',
        location: 328
      },
      {
        name: '2. Something else',
        location: 639
      },
      {
        name: '3. Third Chapter',
        location: 887
      }
    ]
  end

  def highlights
    [
      {
        'asin' => 'B01C5MZGS6',
        'highlight' => 'First.',
        'startLocation' => 15750,
        'endLocation' => 15750,
        'timestamp' => 1_487_747_184_000
      },
      {
        'asin' => 'B01C5MZGS6',
        'highlight' => 'Second',
        'startLocation' => 49050,
        'endLocation' => 49050,
        'timestamp' => 1_487_747_184_000
      },
      {
        'asin' => 'B01C5MZGS6',
        'highlight' => 'Fourth.',
        'startLocation' => 133350,
        'endLocation' => 133350,
        'timestamp' => 1_487_747_184_000
      },
      {
        'asin' => 'B01C5MZGS6',
        'highlight' => 'Fourth Delta.',
        'startLocation' => 135000,
        'endLocation' => 135000,
        'timestamp' => 1_487_747_184_000
      },
      {
        'asin' => 'B01C5MZGS6',
        'highlight' => 'Third.',
        'startLocation' => 100500,
        'endLocation' => 100500,
        'timestamp' => 1_487_747_184_000
      }
    ].sort do |a, b|
      a['startLocation'] <=> b['startLocation']
    end.map do |highlight|
      Kindlemd::Highlight.new(highlight)
    end
  end

  def test_that_it_calls_highlights_for
    book = Kindlemd::Book.new('What works', chapters)
    book.highlights = highlights

    first = book.chapters[0]

    assert_equal 1, first.highlights.size

    second = book.chapters[1]
    assert_equal 1, second.highlights.size

    last = book.chapters[4]
    assert_equal 2, last.highlights.size
  end

  def test_that_it_generates_md
    book = Kindlemd::Book.new('What works', chapters)
    book.highlights = highlights

    sample = File.read('test/fixtures/sample.md')
    File.write('test/fixtures/out.md', book.to_md)

    assert_equal sample, book.to_md
  end
end
