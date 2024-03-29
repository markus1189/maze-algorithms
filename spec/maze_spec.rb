#!/usr/bin/env ruby -w
require 'spec_helper'
# Author: markus1189@gmail.com

describe "Maze" do
  before(:each) do
    @maze = Maze.new(20, 10)
  end

  context "fresh after init" do
    it "should have the given width and height" do
      @maze.width.should eq(20)
      @maze.height.should eq(10)
    end

    specify { @maze.should_not be_solvable }

    specify { @maze.should have_wall_at(0,0, :S)}
    specify { @maze.should have_wall_at(0,0, :E)}
  end

  context "when using calc_dir" do

    it "should calculate the dir between two coordinates" do
      @maze.calc_dir([5,5],[5,4]).should eq(:N)
      @maze.calc_dir([5,5],[5,6]).should eq(:S)
      @maze.calc_dir([5,5],[4,5]).should eq(:W)
      @maze.calc_dir([5,5],[6,5]).should eq(:E)

      @maze.calc_dir([-5,-5],[-5,-6]).should eq(:N)
      @maze.calc_dir([-5,-5],[-5,-4]).should eq(:S)
      @maze.calc_dir([-5,-5],[-6,-5]).should eq(:W)
      @maze.calc_dir([-5,-5],[-4,-5]).should eq(:E)
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

  context "when using [] operator" do

    it "should get the corresponding cell" do
      @maze[0,0].should eq(0)
      @maze.carve_wall([0,0],[0,1])
      @maze.carve_wall([0,0],[1,0])
      @maze[0,0].should_not eq(0)
    end

    it "should be allowed to use negative indexes" do
      10.times do
        rnd_x = rand(@maze.width-1)
        rnd_y = rand(@maze.height-1)
        @maze.carve_wall([rnd_x,rnd_y],[rnd_x,rnd_y+1])

        @maze[rnd_x, rnd_y].should eq( @maze[rnd_x-@maze.width,rnd_y-@maze.height])
      end
    end

  end

  context "when comparing and combining mazes" do
    it "should be comparable to other mazes via ==" do
      maze1 = Maze.new(5,5)
      maze2 = Maze.new(5,5)
      maze3 = Maze.new(42,42)

      maze1.should eq(maze2)
      maze2.should eq(maze1)

      maze1.should_not eq(maze3)
      maze2.should_not eq(maze3)

      maze1.should_not eq(1)
      maze1.should_not eq("1")
    end

    it "should append the second maze below the first using merge!" do
      maze1 = Maze.new(5,37)
      maze2 = Maze.new(5,5)
      resulting_maze = Maze.new(5,42)

      maze1.merge!(maze2)
      maze1.width.should  eq(5)
      maze1.height.should eq(42)

      maze2.width.should  eq(5)
      maze2.height.should eq(5)

      maze1.should eq(resulting_maze)
    end
  end

  context "when trying to get neighbours" do
    it "should return coords for all directions if the position allows it" do
      maze = Maze.new(5, 5)
      keys = Maze::MOVES.keys.size
      maze.should have(keys).neighbours(2,2)
    end

    it "should only return the possible neighbours" do
      maze = Maze.new(3, 3)
      maze.neighbours(0,0).size.should < Maze::MOVES.keys.size

      maze = Maze.new(1, 1)
      maze.should have(0).neighbours(0,0)
    end

  end

  context "when editing walls" do
    before(:each) do
      @maze1 = Maze.new(5,5)
    end

    it "should be able to carve and add walls" do
      [[[0,0],[0,1]], [[3,3],[2,3]]].each do |edge|
        @maze1.should have_wall_between(*edge)
        @maze1.carve_wall(*edge)
        @maze1.should_not have_wall_between(*edge)
        @maze1.add_wall(*edge)
        @maze1.should have_wall_between(*edge)
      end
    end

    it "should not be able to add/carve walls to the outside"
  end

end

