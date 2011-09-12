require 'spec_helper'

describe "State for ellers algortihm" do
  context "when initialized" do

    it "should not lose cells after random_join" do
      50.times do
        MazeGeneration::EllersState.new(9).random_join.flatten.size.should == 9
      end
    end

    it "should not create nil-arrays with random_veritcals" do
      50.times do
        state = MazeGeneration::EllersState.new(9)
        state.random_join
        state.random_vertical.each do |ary|
          ary.compact.should_not be_empty
        end
      end
    end

  end
end

