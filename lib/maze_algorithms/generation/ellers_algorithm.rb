# Ellers algorithm for maze generation
#
# Ellers algorithm is special in the way that it does actually only
# operate on one row at a time.
#
# It does so because it associates every cell with a set and by following
# some simple rules can thereby avoid isolated cells and cycles.
#
# Roughly speaken, the algorithm performs the following steps over and over:
# - 1) randomly join adjacent cells that are in disjoint sets
# - 2) randomly determine vertical connections, at least one per set
# - 3) associate the remaining cells to a new set
#
# Example:
#
#    +---+---+---+---+---+---+
#    | 1 | 2 | 3 | 4 | 5 | 6 |   Every cell is assigned to its own set
#    +---+---+---+---+---+---+
#
#    +---+---+---+---+---+---+
#    | 1   1 | 3 | 4   4   4 |   Randomly join adjacent cells if in different sets
#    +---+---+---+---+---+---+
#
#    +---+---+---+---+---+---+
#    | 1   1 | 3 | 4   4   4 |
#    +   +---+   +   +---+   +   Randomly create vertical connections, at least one per set
#    | 1 |   | 3 | 4 |   | 4 |
#    +---+   +---+---+   +---+
#
#    +---+---+---+---+---+---+
#    | 1   1 | 3 | 4   4   4 |
#    +   +---+   +   +---+   +   Assign new cells to a new set
#    | 1 | 5 | 3 | 4 | 6 | 4 |
#    +---+---+---+---+---+---+
#
#    +   +---+   +   +---+   +
#    | 1 | 5 | 3 | 4 | 6 | 4 |   Use the row and start again
#    +---+---+---+---+---+---+
module MazeAlgorithms
  module Generation
    class EllersAlgorithm
      attr_reader :union_find, :result
      def initialize(size)
        @size = size
        @result = Maze.new(size, 1)
        @union_find = UnionFind.new(0...size)
      end

      # Central generate method, same for every algorithm
      #
      # @param width  [Fixnum]
      # @param height [Fixnum]
      #
      # @return [Maze] Returns the generated Maze
      def self.generate(width, height, &blk)
        new(width).step(height, &blk).result
      end

      # The necessary operations for one row are performed N times
      #
      # @param n [Fixnum] the number of steps to perform
      def step(n=10, &blk)
        (n-1).times do
          random_join
          yield @result if block_given?

          vertical_connections
          yield @result if block_given?
        end
        final_row
        yield @result if block_given?

        self
      end

      # Step 1
      # Traverses the row from left to right pairwise,
      # randomly connecting adjacent cells of disjoint sets
      #
      # Appends the resulting row to the resulting maze
      def random_join
        (0...@result.width).each_cons(2) do |cell_1, cell_2|
          next unless coin(true,false)

          if @union_find.find(cell_1) != @union_find.find(cell_2)
            @union_find.union(cell_1, cell_2)
            @result.carve_wall([cell_1,-1],[cell_2,-1])
          end
        end

        self
      end

      # Step 2
      # randomly reassigns cells and carves the walls between rows
      def vertical_connections
        connected_row = Maze.new(@result.width, 1)
        @result << connected_row

        changed_cells = []
        @union_find.each_set do |set_of_cells|
          amnt_cells = rand(set_of_cells.size)+1
          randomly_chosen_cells = set_of_cells.sort_by {rand}.take(amnt_cells)
          randomly_chosen_cells.each do |cell|
            @result.carve_wall([cell,-1],[cell,-2])
            changed_cells << cell
          end
        end
        (@union_find.elements-changed_cells).each { |c| @union_find.reassign(c) }
        self
      end

      # The final row has to be treated slightly different:
      # we have to connect ALL adjacent (but disjoint) cells.
      def final_row
        (0...@result.width).each_cons(2) do |cell_1, cell_2|
          if @union_find.find(cell_1) != @union_find.find(cell_2)
            @union_find.union(cell_1, cell_2)
            @result.carve_wall([cell_1,-1],[cell_2,-1])
          end
        end
      end

      # Randomly choose one of the elements of args
      #
      # @param args [variable args] the args to choose from
      #
      # @return a random chosen element from args
      def coin(*args)
        args.sample
      end

    end
  end
end
