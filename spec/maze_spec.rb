#!/usr/bin/env ruby -w
require 'spec_helper'
# Author: markus1189@gmail.com

describe "Maze" do
  before(:each) do
    @maze = MazeAlgorithms::Maze.new(20, 10)
  end

  it "should have the given width and height" do
    @maze.width.should eq(20)
    @maze.height.should eq(10)
  end

  context "when using calc_dir" do

    it "should calculate the dir between two coordinates" do
      @maze.calc_dir([5,5],[5,4]).should eq(:N)
      @maze.calc_dir([5,5],[5,6]).should eq(:S)
      @maze.calc_dir([5,5],[4,5]).should eq(:W)
      @maze.calc_dir([5,5],[6,5]).should eq(:E)
    end

    it "should raise an error if the points are not neighbours or invalid" do
      pending("disabled for performance")
      expect { @maze.calc_dir([5,5],[0,0]) }.to raise_error( RuntimeError, /adjacent/)
      expect { @maze.calc_dir([-5,-5],[0,0]) }.to raise_error( RuntimeError, /Invalid coords/)
    end

  end

  context "when move_coords used" do

    it "should move the two given coords if possible" do
      @maze.move_coords(5,5, :N).should eq([5,4])
      @maze.move_coords(5,5, :S).should eq([5,6])
      @maze.move_coords(5,5, :W).should eq([4,5])
      @maze.move_coords(5,5, :E).should eq([6,5])
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
      @maze[0,0].should eq(0)
      @maze.carve_wall([0,0],[0,1])
      @maze.carve_wall([0,0],[1,0])
      @maze[0,0].should_not eq(0)
    end

  end

  context "when using []= operator" do
    it "should be able to set values" do
      @maze[0,0] = 5
      @maze[0,0].should eq(5)

      @maze[0,0] += 3
      @maze[0,0].should eq(8)

      @maze[0,0] &= 0
      @maze[0,0].should eq(0)

    end
  end

  context "when comparing and combining mazes" do
    it "should be comparable to other mazes via ==" do
      maze1 =MazeAlgorithms::Maze.new(5,5)
      maze2 =MazeAlgorithms::Maze.new(5,5)
      maze3 =MazeAlgorithms::Maze.new(42,42)

      maze1.should eq(maze2)
      maze2.should eq(maze1)

      maze1.should_not eq(maze3)
      maze2.should_not eq(maze3)
    end

    it "should append the second maze below the first using merge!" do
      maze1 =MazeAlgorithms::Maze.new(5,37)
      maze2 =MazeAlgorithms::Maze.new(5,5)
      resulting_maze =MazeAlgorithms::Maze.new(5,42)

      maze1.merge!(maze2)
      maze1.width.should  eq(5)
      maze1.height.should eq(42)

      maze2.width.should  eq(5)
      maze2.height.should eq(5)

      maze1.should eq(resulting_maze)
    end
  end

end

