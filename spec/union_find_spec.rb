require 'spec_helper'

describe "UnionFind" do
  context "after intialisation" do
    before(:each) do
      @unions = []

      @unions << MazeAlgorithms::UnionFind.new(%w{a b c d e f})
      @unions << MazeAlgorithms::UnionFind.new([1,2,3,4,5,6])
      @unions << MazeAlgorithms::UnionFind.new([[1],[2],[3],[4],[5],[6]])
      @unions << MazeAlgorithms::UnionFind.new([:one,:two,:three,:four])
    end

    it "should assign the entries correctly in a unique set" do
      apply_to_all do |union|
        sets = union.elements.inject([]) { |mem, elem| mem << union.find(elem) }
        sets.size.should == union.elements.size
      end
    end

    it "should be able to merge" do
      apply_to_all do |union|
        one, two = union.elements.take(2)

        union.union(one, two)
        sets = union.elements.inject([]) { |mem, elem| mem << union.find(elem) }
        #sets.uniq.size.should == (union.elements.size-1)

        union.find(one).should == union.find(two)
      end
    end

    it "should correctly determine if elements are in the same set" do
      apply_to_all do |union|
        one, two = union.elements.take(2)

        union.same_set?(one).should be_true
        union.same_set?(one,one).should be_true

        union.same_set?(one,two).should be_false
        union.union(one, two)
        union.same_set?(one, two).should be_true
      end
    end

    it "should raise an error if the element is not found" do
      apply_to_all do |union|
        expect {
          union.union("does not exists", union.elements.first)
        }.to raise_error( ArgumentError, /^Unknown/)
        expect {
          union.union(union.elements.first, "does not exists")
        }.to raise_error( ArgumentError, /^Unknown/)
      end
    end

    it "should be able to automatically reassign elements" do
      apply_to_all do |union|
        rnd = rand(union.elements.size)

        set_before = union.find(union.elements[rnd])
        elems_before = union.elements
        union.reassign(union.elements[rnd])
        set_after = union.find(union.elements[rnd])
        elems_after = union.elements

        set_before.should_not eq(set_after)
        elems_before.should eq(elems_after)
      end
    end

    it "should be possible to iterate over the sets" do
      apply_to_all do |union|

        one, two = union.elements.take(2)
        union.union(one, two)

        sets = []
        union.each_set do |set|
          sets << set
        end

        sets.first.should == [one,two]
      end
    end

    def apply_to_all(&block)
      return unless block_given?
      @unions.each { |union| yield(union) }
    end
  end
end
