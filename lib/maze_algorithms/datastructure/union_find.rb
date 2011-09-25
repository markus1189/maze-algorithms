module MazeAlgorithms
  module Datastructure
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

      def connect(other)
        root.parent = other
      end
      alias_method :link, :connect

      def to_s
        "<#{@key}|#{@parent}>"
      end
    end

    class UnionFind
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
        checked_get_node(source).connect(checked_get_node(target))

        self
      end

      # Given an element, returns the set it is assigned to or nil if not found
      #
      # Example:
      #   find(:b)       # => 2 (Of class Node)
      #   find(:unknown) # => nil
      #
      # NOTE:
      #   The first part is very ugly but is required, because the lookup of reassigned
      #   nodes would point from hash to the wrong node which has wrong connections and
      #   therefore a not perfect maze as consequence
      def find(elem)
        if elem.class == Node then
          elem_node = elem
        else
          elem_node = checked_get_node(elem)
        end

        if elem_node.parent
          elem_node.parent = find(elem_node.parent) #path compression
        else
          return elem_node
        end

        return elem_node.parent
      end

      def reassign(key)
        checked_get_node(key)

        @elem2node[key] = Node.new(key)
      end

      def elements
        @elem2node.keys
      end

      def nodes
        @elem2node.values
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

      # Iterates over every item and therefore compresses all paths
      # NOTE that normally this is done passively when using find(<key<)
      def compress
        @elem2node.each_key { |key| find(key) }
      end

      def checked_get_node(elem)
        @elem2node[elem] || ( raise ArgumentError, "Unknown element: '#{elem}'" )
      end
    end

  end
end
