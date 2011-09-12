require 'set'

module MazeGeneration
  class UnionFind
    def initialize(elems)
      @next_set = 0
      @elem2set_index = {}
      @set2elems = Hash.new { |hsh, key| hsh[key] = Set.new }

      elems.each do |elem|
        @elem2set_index[elem] = @next_set
        @set2elems[@next_set] << elem
        @next_set += 1
      end
    end

    # Merges the elements of source into target
    # thereby REMOVING source from the data
    #
    # Example:
    #   union(set1, set2) # => set1 contains (set1 union set2), set2 is DELETED
    def union(target, source)
      check_present(target, source)

      target_set = @elem2set_index[target]
      source_set = @elem2set_index[source]

      elems_of_source_set = @set2elems[source_set]

      @set2elems[target_set] = ( @set2elems[target_set] | @set2elems.delete(source_set) )

      elems_of_source_set.each { |elem| @elem2set_index[elem] = target_set }

      self
    end

    # Given an element, returns the set it is assigned to or nil if not found
    #
    # Example:
    #   find(:b)       # => 2
    #   find(:unknown) # => nil
    def find(elem)
      @elem2set_index[elem]
    end

    def elements
      @elem2set_index.keys
    end

    # Used to determine if a given number of elements are in the same set
    # the relation is transitive, reflexive and commutative
    #
    # Example:
    #   same_set?(1)         # => always true
    #   same_set?(1,1,...,1) # => always true
    #   same_set?(1,2,3)     # => true if 1,2,3 are in the same set
    def same_set?(*elems)
      return true if elems.uniq.size == 1
      elems.uniq.combination(2).all? do |one, two|
        @elem2set_index[one] == @elem2set_index[two]
      end
    end

    def ai(options = {})
      @elem2set_index.ai(options) + "\n" + @set2elems.ai(options)
    end

    def to_s
      result = ''
      result << "<#{self.class} | "
      result << "next_set: #{@next_set} | "
      result << "elements: #{elements}>"
    end



    def check_present(*elems)
      elems.each do |elem|
        raise ArgumentError, "Unknown element: '#{elem}'" unless @elem2set_index[elem]
      end
      elems
    end
    private :check_present
  end
end
