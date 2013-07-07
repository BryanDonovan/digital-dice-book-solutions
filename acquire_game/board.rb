require 'pp'

# Figures out, on average, how many "turns" it takes to fill an Acquire (board game) board
# to the point where no space remains that has no adjacent occupied spaces.  The turns in
# this case are randomly selected pieces.

module Acquire
  class Cell
    attr_accessor :x_coord, :y_coord

    def initialize(x_coord, y_coord)
      @x_coord = x_coord
      @y_coord = y_coord
      @is_occupied = false
    end

    def occupied?
      @is_occupied
    end

    def empty?
      !@is_occupied
    end

    def occupy!
      @is_occupied = true
    end

    def to_s
      [x_coord, y_coord].to_s
    end
  end

  class Board
    attr_accessor :cells, :length, :width

    def initialize(args={:length => 12, :width => 9})
      @cells = []
      @length = args[:length]
      @width = args[:width]
      @neighbors = {}
      build_board_matrix
    end

    def reset!
      @cells = []
      @neighboring_indexes = {}
      build_board_matrix
    end

    def occupy_cell_at(index)
      @cells[index].occupy!
    end

    def cell_empty_at?(index)
      cell_at(index).empty?
    end

    def full?
      @cells.each_index do |cell_index|
        cell = @cells[cell_index]
        return false if cell.empty?
      end
      return true
    end

    def remote_cells_available?
      @cells.each do |cell|
        return true if cell_has_no_neighbors?(cell)
      end
      return false
    end

    def cell_has_no_neighbors?(cell)
      index = get_index_at([cell.x_coord, cell.y_coord])
      @neighbors[index].each do |neighbor|
        return false if neighbor.occupied?
      end
      return true
    end

    private

    def build_board_matrix
      cell_index = 0
      0.upto(@length - 1) do |x_coord|
        0.upto(@width - 1) do |y_coord|
          @cells[cell_index] = Acquire::Cell.new(x_coord, y_coord)
          cell_index += 1
        end
      end

      @cells.each_with_index do |cell, index|
        @neighbors[index] = get_neighbors(cell)
      end
    end

    def get_neighbors(cell)
      neighbors = []
      neighbor_distances = [[0, 1], [0, -1], [1, 0], [-1, 0]]

      neighbor_distances.each do |n_dists|
        x = cell.x_coord + n_dists[0]
        y = cell.y_coord + n_dists[1]

        if coords_within_bounds?([x, y])
          cell = @cells[get_index_at([x, y])]
          neighbors.push(cell)
        end
      end

      return neighbors
    end

    def get_index_at(coords)
      x_factor = @width * coords[0]
      y_factor = coords[1]
      return x_factor + y_factor
    end

    def coords_within_bounds?(coords)
      x = coords[0]
      y = coords[1]
      return x >= 0 && y >= 0 && x <= @length - 1 && y <= @width - 1
    end
  end

  class CellPicker
    attr_accessor :board, :total_picks

    def initialize(board)
      @board = board
      @total_picks = 0
    end

    def pick
      if @board.full?
        return nil
      end

      loop do
        cell = @board.cells.sample
        if cell.empty?
          cell.occupy!
          @total_picks += 1
          return cell
        end
      end
    end

    def pick_until_no_remote_cells_left
      while @board.remote_cells_available?
        pick
      end
    end
  end
end


if __FILE__ == $0
  runs = 100

  total_picks = 0;

  runs.times do |run|
    board = Acquire::Board.new
    cell_picker = Acquire::CellPicker.new(board)
    cell_picker.pick_until_no_remote_cells_left
    total_picks += cell_picker.total_picks
  end

  puts "Average: #{total_picks/runs.to_f}"
end
