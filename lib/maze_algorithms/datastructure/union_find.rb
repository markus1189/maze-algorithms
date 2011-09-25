module MazeAlgorithms
  module Datastructure
    class Node
      attr_accessor :parent
      attr_reader :key

      def initialize(key)
        @key, @parent = key, nil
      end

      def root
        @parent ? @parent.root : self
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
      def find(key)
        find_node(checked_get_node(key))
      end

      def find_node(elem_node)
        if elem_node.parent
          elem_node.parent = find_node(elem_node.parent) #path compression
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
        "<#{self.class} | elements: #{elements}>"
      end

      private

      def checked_get_node(elem)
        @elem2node[elem] || ( raise ArgumentError, "Unknown element: '#{elem}'" )
      end
    end

  end
end
