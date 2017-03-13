require 'set'

module Kindlemd
  class Document
    def initialize(highlights)
      @nodes = Set.new

      highlights.each do |highlight|
        if highlight.chapter
          @nodes.add(highlight.chapter)
        else
          @nodes.add(highlight)
        end
      end
    end

    attr_reader :nodes
  end
end
