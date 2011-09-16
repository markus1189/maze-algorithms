require 'set'

module MazeAlgorithms
  class Node
    attr_accessor :parent
    attr_reader :key

    def initialize(key)
      @key = key
      @parent = nil
    end

    def root
      if not @parent then self else @parent.root end
    end

    def connected?(other)
      root == other.root
    end

    def connect(other)
      root.parent = other
    end

    def self.to_proc
      lambda { |arg|  new(arg) }
    end

    def to_s
      "<#{@key}|#{@parent}>"
    end
  end

  class UnionFind
    attr_reader :set2elems
    def initialize(elems)
      @elem2node = {}

      elems.each { |elem| @elem2node[elem] = Node.new(elem) }
    end

    # Merges the elements of source into target
    # thereby REMOVING source from the data
    #
    # Example:
    #   union(set1, set2) # => set1 contains (set1 union set2), set2 is DELETED
    def union(target, source)
      check_present(target, source)
      @elem2node[source].connect(@elem2node[target])

      self
    end

    # Given an element, returns the set it is assigned to or nil if not found
    #
    # Example:
    #   find(:b)       # => 2
    #   find(:unknown) # => nil
    def find(elem)
      @elem2node[elem].root
    end

    def reassign(elem)
      unless @elem2node[elem]
        raise ArgumentError, "Element not found: #{elem}"
      end

      @elem2node[elem] = get_new_set(elem)
    end

    def get_new_set(elem)
      Node.new(elem)
    end

    def elements
      @elem2node.keys
    end

    def nodes
      @elem2node.values
    end

    # Used to determine if a given number of elements are in the same set
    # the relation is transitive, reflexive and commutative
    #
    # Example:
    #   same_set?(1)         # => always true
    #   same_set?(1,1,...,1) # => always true
    #   same_set?(1,2,3)     # => true if 1,2,3 are in the same set
    def same_set?(*elems)
      #return true if elems.uniq.size == 1
      elems.uniq.combination(2).all? do |one, two|
        @elem2node[one].connected?(@elem2node[two])
      end
    end

    def to_s
      result = ''
      result << "<#{self.class} | "
      result << "elements: #{elements}>"
    end

    def each_set(&blk)
      return unless block_given?
      set2elems = Hash.new { |hsh, key| hsh[key] = [] }

      nodes.each do |e|
        set2elems[e.root] << e
      end

      set2elems.each_value { |set| yield(set.map { |s| s.key }) }
    end

    private

    def check_present(*elems)
      elems.each do |elem|
        raise ArgumentError, "Unknown element: '#{elem}'" unless @elem2node[elem]
      end

      elems
    end
  end
end
