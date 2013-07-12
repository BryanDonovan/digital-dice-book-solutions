require 'pp'
require 'minitest/spec'
require 'minitest/autorun'
require './board'
require './printer'

describe Acquire::Board do
  describe 'cell_has_no_neighbors?()' do
    describe 'when board is 2x2' do
      before do
        @board = Acquire::Board.new({:length => 2, :width => 2})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at_coords([0, 0])
          Acquire::Printer.print(@board)
        end

        it 'should return true for cell [0, 0]' do
          cell = @board.cell_at(0)
          @board.cell_has_no_neighbors?(cell).must_equal true
        end

        it 'should return false for cell [1, 0]' do
          cell = @board.cell_at(1)
          @board.cell_has_no_neighbors?(cell).must_equal false
        end

        it 'should return false for cell [1, 1]' do
          cell = @board.cell_at(2)
          @board.cell_has_no_neighbors?(cell).must_equal false
        end

        it 'should return false for cell [1, 2]' do
          cell = @board.cell_at(3)
          @board.cell_has_no_neighbors?(cell).must_equal false
        end
      end
    end
  end

  describe 'remote_cells_available?()' do
=begin
    describe 'when board is 1x2' do
      before do
        @board = Acquire::Board.new({:length => 1, :width => 2})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at(0)
          Acquire::Printer.print(@board)
        end

        it 'should be false' do
          @board.remote_cells_available?().must_equal false
        end
      end
    end
=end

    describe 'when board is 2x2' do
      before do
        @board = Acquire::Board.new({:length => 2, :width => 2})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at(0)
          Acquire::Printer.print(@board)
        end

        it 'should be true' do
          @board.remote_cells_available?().must_equal true
        end
      end
    end

=begin
    describe 'when board is 3x1' do
      before do
        @board = Acquire::Board.new({:length => 3, :width => 1})
      end

      describe 'and cell [0, 0] is occupied' do
        before do
          @board.occupy_cell_at(0)
          Acquire::Printer.print(@board)
        end

        it 'should be true' do
          @board.remote_cells_available?().must_equal true
        end
      end

      describe 'and cell [0, 1] is occupied' do
        before do
          @board.reset!
          @board.occupy_cell_at(1)
          Acquire::Printer.print(@board)
        end

        it 'should be false' do
          @board.remote_cells_available?().must_equal false
        end
      end
    end
=end
  end
end
