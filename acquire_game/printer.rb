require 'pp'
require './board'

module Acquire
  class Printer

    def initialize(board)
      @board = board
    end

    def self.print(board)
      Acquire::Printer.new(board).to_ascii
    end

    def to_ascii
      rows = []
      0.upto(@board.width - 1) do |i|
        rows.push []
      end

      @board.cells.each do |cell|
        rows[cell.y_coord].push(cell)
      end

      rows.each do |row|
        str = ''
        str += "\n"
        str += '-' * (@board.length * 2 + 1)
        str += "\n"
        row.each do |cell|
          str += '|'
          if cell.occupied?
            str += "\e[\033[32m" + '#' + "\e[0m"
          else
            str += ' '
          end
        end
        str += '|'
        print str
      end
      puts "\n"
      puts '-' * (@board.length * 2 + 1)
      puts
    end
  end
end

if __FILE__ == $0
  board = Acquire::Board.new(:length => 12, :width => 9)
  cell_picker = Acquire::CellPicker.new(board)
  5.times do
    cell_picker.pick
  end
  printer = Acquire::Printer.new(board)
  printer.to_ascii
end
