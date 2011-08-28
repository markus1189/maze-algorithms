require 'spec_helper'
# Author: markus1189@gmail.com

describe Maze do
  before(:each) do
    @maze = Maze.new(20, 10)
  end

  it "should have the given width and height" do
    @maze.width.should  == 20
    @maze.height.should == 10
  end

  context "when using calc_dir" do

    it "should calculate the dir between two coordinates" do
      @maze.calc_dir([5,5],[5,4]).should == :N
      @maze.calc_dir([5,5],[5,6]).should == :S
      @maze.calc_dir([5,5],[4,5]).should == :W
      @maze.calc_dir([5,5],[6,5]).should == :E
    end

    it "should raise an error if the points are not neighbours or invalid" do
      pending("disabled for performance")
      expect { @maze.calc_dir([5,5],[0,0]) }.to raise_error( RuntimeError, /adjacent/)
      expect { @maze.calc_dir([-5,-5],[0,0]) }.to raise_error( RuntimeError, /Invalid coords/)
    end

  end

  context "when move_coords used" do

    it "should move the two given coords if possible" do
      @maze.move_coords(5,5, :N).should == [5,4]
      @maze.move_coords(5,5, :S).should == [5,6]
      @maze.move_coords(5,5, :W).should == [4,5]
      @maze.move_coords(5,5, :E).should == [6,5]
    end

    it "should return nil if moving is not possible" do
      @maze.move_coords(0,0, :W).should be_nil
      @maze.move_coords(0,0, :N).should be_nil

      @maze.move_coords(19,9, :E).should be_nil
      @maze.move_coords(19,9, :S).should be_nil
    end

  end

  context "when using carve_wall" do
    it "should raise an error if not possible" do
      pending("disabled for performance")
      expect { @maze.carve_wall([0,0], [0,-1]) }.to raise_error( RuntimeError, /Invalid coords/ )
      expect { @maze.carve_wall([0,0], [0, 5]) }.to raise_error( RuntimeError, /adjacent/ )

      @maze.should have_wall_between([0,0],[0,1])
      @maze.carve_wall([0,0],[0,1])
      @maze.should_not have_wall_between([0,0],[0,1])

      @maze.should have_wall_between([5,5],[5,4])
      @maze.carve_wall([5,5],[5,4])
      @maze.should_not have_wall_between([5,5],[5,4])
    end
  end

  context "when using [] operator" do

    it "should get the corresponding cell" do
      @maze[0,0].should == 0
      @maze.carve_wall([0,0],[0,1])
      @maze.carve_wall([0,0],[1,0])
      @maze[0,0].should_not == 0
    end

  end

  context "when using []= operator" do
    it "should be able to set values" do
      @maze[0,0] = 5
      @maze[0,0].should == 5

      @maze[0,0] += 3
      @maze[0,0].should == 8

      @maze[0,0] &= 0
      @maze[0,0].should == 0

    end
  end

end

