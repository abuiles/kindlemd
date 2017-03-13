require 'test_helper'
require 'pry'

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
        "asin"=>"B01C5MZGS6",
        "highlight"=>"First.",
        "startLocation"=>105,
        "endLocation"=>105,
        "timestamp"=>1487747184000
      },
      {
        "asin"=>"B01C5MZGS6",
        "highlight"=>"Second",
        "startLocation"=>327,
        "endLocation"=>330,
        "timestamp"=>1487747184000
      },
      {
        "asin"=>"B01C5MZGS6",
        "highlight"=>"Fourth.",
        "startLocation"=>889,
        "endLocation"=>990,
        "timestamp"=>1487747184000
      },
      {
        "asin"=>"B01C5MZGS6",
        "highlight"=>"Fourth Delta.",
        "startLocation"=>900,
        "endLocation"=>990,
        "timestamp"=>1487747184000
      },
      {
        "asin"=>"B01C5MZGS6",
        "highlight"=>"Third.",
        "startLocation"=>670,
        "endLocation"=>690,
        "timestamp"=>1487747184000
      }
    ].sort{ |a,b|
      a["startLocation"] <=> b["startLocation"]
    }.map{ |highlight|
      Kindlemd::Highlight.new(highlight)
    }
  end

  def test_that_it_calls_highlights_for
    book = Kindlemd::Book.new("What works", chapters)
    book.highlights = highlights

    first = book.chapters[0]

    assert_equal 1, first.highlights.size

    second = book.chapters[1]
    assert_equal 1, second.highlights.size

    last = book.chapters[4]
    assert_equal 2, last.highlights.size
  end

  def test_that_it_generates_md
    book = Kindlemd::Book.new("What works", chapters)
    book.highlights = highlights

    sample = File.read('test/sample.md')

    assert_equal sample, book.to_md
  end
end
