require 'kindle_highlights'
require 'hashie'
require 'pry'

module Kindlemd
  class Highlight < Hashie::Mash
    def self.fetch(kindle, asin)
      kindle.highlights_for(asin).sort{|a,b|
        a["startLocation"] <=> b["startLocation"]
      }.map{|highlight|
        new(highlight)
      }
    end

    def <=>(anOther)
      location <=> anOther.location
    end

    def to_md
      "---\n\n> #{highlight}\n\n---\n#{link}"
    end

    def link
      "[Read more at location #{location}](kindle://book?action=open&asin=#{asin}&location=#{location})"
    end

    def location
      # https://www.amazon.com/forum/kindle/Tx2S4K44LSXEWRI?_encoding=UTF8&cdForum=Fx1D7SY3BVSESG
      (startLocation / 150.0).ceil
    end
  end
end
