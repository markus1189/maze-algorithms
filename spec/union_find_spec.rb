require 'spec_helper'

describe "UnionFind" do
  context "after intialisation" do
    before(:each) do
      @unions = []

      @unions << UnionFind.new(%w{a b c d e f})
    end

    it "should assign the entries correctly in a unique set" do
      @unions.each do |union|
        sets = union.elements.inject([]) { |mem, elem| mem << union.find(elem) }
        sets.size.should == union.elements.size
      end
    end

    it "should be able to merge" do
      @unions.each do |union|
        one, two = union.elements.take(2)

        union.union(one, two)
        sets = union.elements.inject([]) { |mem, elem| mem << union.find(elem) }
        sets.uniq.size.should == (union.elements.size-1)

        union.find(one).should == union.find(two)
      end
    end
  end
end
