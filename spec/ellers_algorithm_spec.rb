require 'spec_helper'
# Author: markus1189@gmail.com

describe "Ellers algorithm" do
  context "when using random_join method" do
    before(:each) do
      @maze = mock('maze')
      @maze.should_receive(:width).at_least(:once).and_return(5)
      @ellers = EllersAlgorithm.new(@maze)
    end
    it "should randomly join cells in the row" do
      @maze.should_receive(:carve_wall).at_most(@maze.width).times
      @maze.should_receive(:has_wall_between?).at_most(@maze.width).times
      @ellers.random_join([3,3,3,3,3], 0)
    end

    it "should assign the right set number when joining single cell to multi set" do
      3.times do #generation is random
        maze = Maze.new(10, 1)
        ellers_algo = EllersAlgorithm.new(maze)
        ellers_algo.random_join(maze.get_row(0), 0)
        generated_row = maze.get_row(0)
        set = ellers_algo.set

        generated_row.each.with_index do |cell, i|
          h = i-1
          j = i+1

          if i == 0
            (set[i] == set[j]).should_not == maze.has_wall_between?([i,0],[j,0])
            next
          elsif i == generated_row.size-1
            (set[i] == set[h]).should_not == maze.has_wall_between?([i,0],[h,0])
            next
          else
            (set[i] == set[h]).should_not == maze.has_wall_between?([i,0],[h,0])
            (set[i] == set[j]).should_not == maze.has_wall_between?([i,0],[j,0])
          end
        end
      end
    end
  end

  context "when using assing_to_set" do
    before(:each) do
      @maze = mock('maze')
      @maze.should_receive(:width).at_least(:once).and_return(5)
      @ellers = EllersAlgorithm.new(@maze)
    end

    it "should initialize the empty set with indexes from 0 to width-1" do
      @ellers.set.should == (0...@maze.width).to_a
    end

    it "should be able to fill 'nil' sets with new set indexes" do
      @ellers.assign_missing([1, 2, nil, nil, 3, 5]).should == [1,2,6,7,3,5]
    end
  end

  context "Array extension count_block_size" do
    it "should count the size of a block of equal objects" do
      [1,2,2,2,3,4,4].count_block_size(0,2).should == 0
      [1,2,2,2,3,4,4].count_block_size(3,3).should == 0
      [1,2,2,2,3,4,4].count_block_size(6,2).should == 0

      [1,2,2,2,3,4,4].count_block_size(0,1).should == 1

      [1,2,2,2,3,4,4].count_block_size(5,4).should == 2
      [1,2,2,2,3,4,4].count_block_size(6,4).should == 2

      [1,2,2,2,3,4,4].count_block_size(1,2).should == 3
      [1,2,2,2,3,4,4].count_block_size(2,2).should == 3
      [1,2,2,2,3,4,4].count_block_size(3,2).should == 3
    end
  end
end

