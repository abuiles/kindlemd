require 'set'

module Kindlemd
  class Book
    def initialize(title, chapters)
      @title = title
      @chapters = Chapter.normalize(chapters).map{|chapter|
        Chapter.new(chapter)
      }
    end

    attr_reader :title, :chapters, :highlights

    def highlights=(highlights)
      merge_highlights(highlights)
    end

    # Add chapter to each highlight
    def merge_highlights(highlights)
      @highlights = SortedSet.new(highlights)

      chapters.each do |chapter|
        # meee
        @highlights.each do |highlight|
          highlight.book = self
          chapter.add_highlight(highlight)
        end
      end
    end

    def to_md
      document = Document.new(highlights)
      markdown = ["# #{title}"]

      document.nodes.each do |node|
        if node.is_a?(Chapter)
          markdown = markdown + node.to_md
        else
          markdown.push(node.to_md)
        end
      end

      markdown.join("\n\n")
    end
  end
end
