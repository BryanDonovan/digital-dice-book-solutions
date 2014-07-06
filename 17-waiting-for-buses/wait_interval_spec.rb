require '../ruby_setup'
require './buses'

describe WaitInterval do
  describe "#wait_time" do
    describe "when arrival_time is 0" do
      before(:each) do
        @arrival_time = 0
      end

      describe "and start_time is 0.20" do
        before(:each) do
          @start_time = 0.20
          @wait_interval = WaitInterval.new(start_time: @start_time, arrival_time: @arrival_time)
        end

        it "should be 48" do
          @wait_interval.wait_time.must_equal(48.0)
        end
      end

      describe "and start_time is 0.05" do
        before(:each) do
          @start_time = 0.05
          @wait_interval = WaitInterval.new(start_time: @start_time, arrival_time: @arrival_time)
        end

        it "should be 57" do
          @wait_interval.wait_time.must_equal(57.0)
        end
      end

      describe "and start_time is 0.95" do
        before(:each) do
          @start_time = 0.95
          @wait_interval = WaitInterval.new(start_time: @start_time, arrival_time: @arrival_time)
        end

        it "should be 3" do
          @wait_interval.wait_time.must_be_close_to(3.0, 0.001)
        end
      end
    end

    describe "when arrival_time is 0.5" do
      before(:each) do
        @arrival_time = 0.5
      end

      describe "and start_time is 0.20" do
        before(:each) do
          @start_time = 0.20
          @wait_interval = WaitInterval.new(start_time: @start_time, arrival_time: @arrival_time)
        end

        it "should be 18" do
          @wait_interval.wait_time.must_equal(18.0)
        end
      end

      describe "and start_time is 0.05" do
        before(:each) do
          @start_time = 0.05
          @wait_interval = WaitInterval.new(start_time: @start_time, arrival_time: @arrival_time)
        end

        it "should be 27" do
          @wait_interval.wait_time.must_equal(27.0)
        end
      end

      describe "and start_time is 0.95" do
        before(:each) do
          @start_time = 0.95
          @wait_interval = WaitInterval.new(start_time: @start_time, arrival_time: @arrival_time)
        end

        it "should be 33" do
          @wait_interval.wait_time.must_be_close_to(33.0, 0.001)
        end
      end
    end
  end
end
