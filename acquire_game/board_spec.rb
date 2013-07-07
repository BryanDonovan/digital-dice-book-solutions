require 'pp'
require 'minitest/spec'
require 'minitest/autorun'
require './board'
require './printer'

describe Acquire::Board do
  describe 'remote_cells_available?()' do
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
  end
end
