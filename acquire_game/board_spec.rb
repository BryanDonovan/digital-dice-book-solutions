require 'pp'
require 'minitest/spec'
require 'minitest/autorun'
require './board'
require './printer'

describe Acquire::Board do
  describe 'get_neighbors()' do
    def assert_neighbors_include_coords(neighbors, expected_coords)
      expected_coords.each do |expected|
        matched = false
        neighbors.each do |neighbor|
          if neighbor.x_coord == expected[0] && neighbor.y_coord == expected[1]
            matched = true
          end
        end
        matched.must_equal true
      end
    end

    describe 'when board is 2x2' do
      before do
        @board = Acquire::Board.new({:length => 2, :width => 2})
      end

      describe 'and cell is [0, 0]' do
        it 'should return [0, 1] and [1, 0]]' do
          cell = @board.cell_at_coords([0, 0])
          neighbors = @board.get_neighbors(cell)
          neighbors.length.must_equal 2
          expected_coords = [[0, 1], [1, 0]]
          assert_neighbors_include_coords(neighbors, expected_coords)
        end
      end

      describe 'and cell is [0, 1]' do
        it 'should return [0, 0] and [1, 1]]' do
          cell = @board.cell_at_coords([0, 1])
          neighbors = @board.get_neighbors(cell)
          neighbors.length.must_equal 2
          expected_coords = [[0, 0], [1, 1]]
          assert_neighbors_include_coords(neighbors, expected_coords)
        end
      end
    end

    describe 'when board is 3x3' do
      before do
        @board = Acquire::Board.new({:length => 3, :width => 3})
      end

      describe 'and cell is [0, 0]' do
        it 'should return [0, 1] and [1, 0]]' do
          cell = @board.cell_at_coords([0, 0])
          neighbors = @board.get_neighbors(cell)
          neighbors.length.must_equal 2
          expected_coords = [[0, 1], [1, 0]]
          assert_neighbors_include_coords(neighbors, expected_coords)
        end
      end

      describe 'and cell is [1, 0]' do
        it 'should return [0, 0], [1, 1], [2, 0]' do
          cell = @board.cell_at_coords([1, 0])
          neighbors = @board.get_neighbors(cell)
          neighbors.length.must_equal 3
          expected_coords = [[0, 0], [1, 1], [2, 0]]
          assert_neighbors_include_coords(neighbors, expected_coords)
        end
      end

      describe 'and cell is [1, 1]' do
        it 'should return [0, 1], [1, 0], [2, 1], [1, 2]]' do
          cell = @board.cell_at_coords([1, 1])
          neighbors = @board.get_neighbors(cell)
          neighbors.length.must_equal 4
          expected_coords = [[0, 1], [1, 0], [2, 1], [1, 2]]
          assert_neighbors_include_coords(neighbors, expected_coords)
        end
      end
    end
  end

  describe 'cell_has_no_neighbors?()' do
    describe 'when board is 2x2' do
      before do
        @board = Acquire::Board.new({:length => 2, :width => 2})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at_coords([0, 0])
          #Acquire::Printer.print(@board)
        end

        it 'should return true for cell [0, 0]' do
          cell = @board.cell_at_coords([0, 0])
          @board.cell_has_no_neighbors?(cell).must_equal true
        end

        it 'should return false for cell [1, 0]' do
          cell = @board.cell_at_coords([1, 0])
          @board.cell_has_no_neighbors?(cell).must_equal false
        end

        it 'should return false for cell [0, 1]' do
          cell = @board.cell_at_coords([0, 1])
          @board.cell_has_no_neighbors?(cell).must_equal false
        end

        it 'should return false for cell [1, 1]' do
          cell = @board.cell_at_coords([1, 1])
          @board.cell_has_no_neighbors?(cell).must_equal true
        end
      end
    end
  end

  describe 'remote_cells_available?()' do
    describe 'when board is 1x2' do
      before do
        @board = Acquire::Board.new({:length => 1, :width => 2})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at_coords([0, 0])
          Acquire::Printer.print(@board)
        end

        it 'should be false' do
          @board.remote_cells_available?().must_equal false
        end
      end
    end

    describe 'when board is 2x2' do
      before do
        @board = Acquire::Board.new({:length => 2, :width => 2})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at_coords([0, 0])
          Acquire::Printer.print(@board)
        end

        it 'should be true' do
          @board.remote_cells_available?().must_equal true
        end
      end
    end

    describe 'when board is 3x1' do
      before do
        @board = Acquire::Board.new({:length => 3, :width => 1})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at_coords([0, 0])
          Acquire::Printer.print(@board)
        end

        it 'should be true' do
          @board.remote_cells_available?().must_equal true
        end
      end

      describe 'and cell [0, 1] is occupied' do
        before do
          @board.reset!
          @board.occupy_cell_at_coords([0, 1])
          Acquire::Printer.print(@board)
        end

        it 'should be false' do
          @board.remote_cells_available?().must_equal false
        end
      end
    end

    describe 'when board is 4x1' do
      before do
        @board = Acquire::Board.new({:length => 4, :width => 1})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at_coords([0, 0])
          Acquire::Printer.print(@board)
        end

        it 'should be true' do
          @board.remote_cells_available?().must_equal true
        end
      end

      describe 'and cell [0, 1] is occupied' do
        before do
          @board.reset!
          @board.occupy_cell_at_coords([0, 1])
          Acquire::Printer.print(@board)
        end

        it 'should be true' do
          @board.remote_cells_available?().must_equal true
        end

        describe 'and cell [0, 2] is occupied (along with [0, 1])' do
          before do
            @board.occupy_cell_at_coords([0, 2])
            Acquire::Printer.print(@board)
          end

          it 'should be false' do
            @board.remote_cells_available?().must_equal false
          end
        end
      end
    end

    describe 'when board is 3x3' do
      before do
        @board = Acquire::Board.new({:length => 3, :width => 3})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.reset!
          @board.occupy_cell_at_coords([0, 0])
          Acquire::Printer.print(@board)
        end

        it 'should be true' do
          @board.remote_cells_available?().must_equal true
        end
      end

      describe 'and cell [1, 1] is occupied' do
        before do
          @board.reset!
          @board.occupy_cell_at_coords([1, 1])
          Acquire::Printer.print(@board)
        end

        it 'should be true' do
          @board.remote_cells_available?().must_equal true
        end
      end

      describe 'and cell [1, 1] is occupied along with all corners' do
        before do
          @board.reset!
          @board.occupy_cell_at_coords([1, 1])
          @board.occupy_cell_at_coords([0, 0])
          @board.occupy_cell_at_coords([0, 2])
          @board.occupy_cell_at_coords([2, 0])
          @board.occupy_cell_at_coords([2, 2])
          Acquire::Printer.print(@board)
        end

        it 'should be false' do
          @board.remote_cells_available?().must_equal false
        end
      end
    end
  end
end
