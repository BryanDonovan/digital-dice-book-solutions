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
    attr_accessor :cells, :cell_indexes, :length, :width

    def initialize(args={:length => 12, :width => 9})
      @cells = {}
      @cell_indexes = []
      @length = args[:length]
      @width = args[:width]
      @neighboring_indexes = {}
      build_board_matrix
    end

    def occupy_cell_at(index)
      @cells[index].occupy!
    end

    def cell_at(index)
      @cells[index]
    end

    def cell_empty_at?(index)
      cell_at(index).empty?
    end

    def full?
      @cell_indexes.each do |cell_index|
        cell = cell_at(cell_index)
        return false if cell.empty?
      end
      return true
    end

    def remote_cells_available?
      @cell_indexes.each do |cell_index|
        return true if cell_index_has_no_neighbors?(cell_index)
      end
      return false
    end

    def cell_index_has_no_neighbors?(index)
      @neighboring_indexes[index].each do |n_index|
        return false if !cell_empty_at?(n_index)
      end

      return true
    end

    private

    def build_board_matrix
      cell_index = 0
      0.upto(@length - 1) do |x_coord|
        0.upto(@width - 1) do |y_coord|
          @cells[cell_index] = Acquire::Cell.new(x_coord, y_coord)
          @cell_indexes.push(cell_index)
          get_neighboring_indexes(cell_index)
          @neighboring_indexes[cell_index] = get_neighboring_indexes(cell_index)
          cell_index += 1
        end
      end
    end

    def get_neighboring_indexes(index)
      cell = cell_at(index)
      neighbors = []
      neighbor_distances = [[0, 1], [0, -1], [1, 0], [-1, 0]]

      neighbor_distances.each do |n_dists|
        x = cell.x_coord + n_dists[0]
        y = cell.y_coord + n_dists[1]

        if coords_within_bounds?([x, y])
          neighbors.push(get_index_at([x, y]))
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

      successfull_choice = false

      until successfull_choice do
        index_choice = @board.cell_indexes.sample
        if @board.cell_empty_at?(index_choice)
          @board.occupy_cell_at(index_choice)
          successfull_choice = true
        end
      end

      @total_picks += 1
      return @board.cell_at(index_choice)
    end

    def pick_until_no_remote_cells_left
      while @board.remote_cells_available?
        pick
      end
    end
  end
end


runs = 1000

total_picks = 0;

runs.times do |run|
  board = Acquire::Board.new
  cell_picker = Acquire::CellPicker.new(board)
  cell_picker.pick_until_no_remote_cells_left
  total_picks += cell_picker.total_picks
end

puts "Average: #{total_picks/runs.to_f}"
