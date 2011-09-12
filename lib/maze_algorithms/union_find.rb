require 'set'

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
  #   union(set1, set2) # => set1 contains set1 union set2, set2 is deleted
  def union(target, source)
    target_set = @elem2set_index[target]
    source_set = @elem2set_index[source]

    elems_of_source_set = @set2elems[source_set]

    @set2elems[target_set] = ( @set2elems[target_set] | @set2elems.delete(source_set) )

    elems_of_source_set.each { |elem| @elem2set_index[elem] = target_set }
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
end
