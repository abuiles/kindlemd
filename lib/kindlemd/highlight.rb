require 'kindle_highlights'
require 'hashie'

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
      startLocation <=> anOther.startLocation
    end

    def to_markdown
      "> #{highlight}"
    end
  end
end
