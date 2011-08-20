#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')

require 'buckblogs_eller'

describe "State" do
  context "when initialized" do
    before(:each) do
      @state = State.new(5)
    end

    it "has -1 as next set" do
      @state.next_set.should == (1-2)
    end

    it "should order every cell in its own set after populate" do
      @state.populate
      p @state.next_set
      p @state.sets
      p @state.cells
    end
  end
end

