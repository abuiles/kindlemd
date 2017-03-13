require 'set'
require 'hashie'

module Kindlemd
  class Chapter < Hashie::Mash
    def highlights
      @highlights ||= SortedSet.new
    end

    def add_highlight(highlight)
      return false unless owns?(highlight)

      highlights.add(highlight)
      highlight.chapter = self
      true
    end

    def owns?(highlight)
      if next_chapter
        highlight.location.between?(location, next_chapter)
      else
        highlight.location >= location
      end
    end

    def to_markdown
      nodes = ["## #{name}"]

      highlights.each do |highlight|
        nodes.push(highlight.to_markdown)
      end

      nodes
    end

    # Receives a list of chapters in the form of {name:, location}:
    # chapters = [
    #   {
    #     name: 'The promise of Behavioral Design',
    #     location: 105
    #   },
    #   {
    #     name: 'Part One: The problem',
    #     location: 324
    #   }]
    #
    # Returns a list of normalized chapters, adding the "next" and "previous" chapter.

    # chapters = [
    #   {
    #     name: 'The promise of Behavioral Design',
    #     location: 105,
    #     next: 324,
    #     previous: nil
    #   },
    #   {
    #     name: 'Part One: The problem',
    #     location: 324,
    #     previous: 105,
    #     next: 328
    #   }]
    def  self.normalize(chapters)
      enum = chapters.sort{ |c,d|
        c[:location] <=> d[:location]
      }.to_enum

      searching = true

      while searching
        begin
          chapter = enum.next
          next_chapter = enum.peek
          chapter[:next_chapter] = next_chapter[:location]
          next_chapter[:previous] = chapter[:location]
        rescue StopIteration
          searching = false
        end
      end

      enum.to_a
    end
  end
end
