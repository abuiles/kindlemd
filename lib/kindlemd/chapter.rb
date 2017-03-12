module Kindlemd
  class Chapter
    # Receives a list of chapters in the form of {name:, position}:
    # chapters = [
    #   {
    #     name: 'The promise of Behavioral Design',
    #     position: 105
    #   },
    #   {
    #     name: 'Part One: The problem',
    #     position: 324
    #   }]

    # Returns a list of normalized chapters, adding the "next" and "previous" chapter.

    # chapters = [
    #   {
    #     name: 'The promise of Behavioral Design',
    #     position: 105,
    #     next: 324,
    #     previous: nil
    #   },
    #   {
    #     name: 'Part One: The problem',
    #     position: 324,
    #     previous: 105,
    #     next: 328
    #   }]
    def  self.normalize(chapters)
      enum = chapters.sort{ |c,d|
        c[:position] <=> d[:position]
      }.to_enum

      searching = true

      while searching
        begin
          chapter = enum.next
          next_chapter = enum.peek
          chapter[:next] = next_chapter[:position]
          next_chapter[:previous] = chapter[:position]
        rescue StopIteration
          searching = false
        end
      end

      enum.to_a
    end
  end
end
