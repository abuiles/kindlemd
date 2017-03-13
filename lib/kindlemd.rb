require "kindlemd/version"
require "kindlemd/chapter"
require "kindlemd/highlight"
require "kindlemd/document"
require "kindlemd/book"
require 'kindle_highlights'

module Kindlemd
  def self.auth(kindle)
    begin
      kindle.send(:conditionally_sign_in_to_amazon)
      true
    rescue KindleHighlights::Client::AuthenticationError
      false
    end
  end

  def self.run
    email_address = ENV['KINDLE_EMAIL']
    password = ENV['KINDLE_PASSWORD']

    kindle = KindleHighlights::Client.new(email_address: email_address, password: password)

    did_auth = false

    while not did_auth
      # for some reason we need to call auth several times
      did_auth = self.auth(kindle)
    end

    puts "did auth"

    chapters = [
      {
        name: 'The Promise of Behavioral Design',
        location: 105
      },
      {
        name: 'Part One: The Problem',
        location: 324
      },
      {
        name: '1. Unconscious Bias Is Everywhere',
        location: 328
      },
      {
        name: '2. De-Biasing Minds Is Hard',
        location: 639
      },
      {
        name: '3. Doing It Yourself Is Risky',
        location: 887
      },
      {
        name: '4. Getting Help Only Takes You So Far',
        location: 1160
      },
      {
        name: 'Part Two How to design talent management',
        location: 1408
      },
      {
        name: '5. Applying Data to People Decisions',
        location: 1412
      },
      {
        name: '6. Orchestrating Smarter Evaluation Procedures',
        location: 1687
      },
      {
        name: '7. Attracting the Right People',
        location: 1987
      },
      {
        name: 'Part Three: How to design school and work',
        location: 2247
      },
      {
        name: '8. Adjusting Risk',
        location: 2252
      },
      {
        name: '9. Leveling the Playing Field',
        location: 2463
      },
      {
        name: 'Part Four: How to design diversity',
        location: 2696
      },
      {
        name: '10. Creating Role Models',
        location: 2697
      },
      {
        name: '11. Crafting Groups',
        location: 2928
      },
      {
        name: '12. Shaping Norms',
        location: 3251
      },
      {
        name: '13. Increasing Transparency',
        location: 3517
      },
      {
        name: 'Designing Change',
        location: 3760
      }
    ]

    puts "fetching highlights"

    book = Kindlemd::Book.new("What works", chapters)
    book.highlights = Highlight.fetch(kindle, "B01C5MZGS6")

    # File.write('whatworks.md', book.to_md)
  end
end
