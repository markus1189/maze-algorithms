# Author: markus1189@gmail.com
require 'spec_helper'

describe "Cell" do
  context "when calling dynamically defined methods" do

    before(:each) do
      @cell = MazeAlgorithms::Cell.new
    end

    it "should respond correctly to all four directions's reader/writer" do
      %w{north south west east}.each_with_index do |dir, i|
        @cell.send(dir + '?').should == false
        @cell.send(dir + '!')
        @cell.send(dir + '?').should == true
      end
    end
  end
end

