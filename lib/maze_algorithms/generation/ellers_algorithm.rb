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
      attr_reader :union_find, :resulting_maze

      def initialize(size)
        @size = size
        @resulting_maze = Maze.new(size, 1)
        @uf = UnionFind.new(0...size)
      end

      # Central generate method, same for every algorithm
      #
      # @param width  [Fixnum]
      # @param height [Fixnum]
      #
      # @return [Maze] Returns the generated Maze
      def self.generate(width, height, &blk)
        new(width).step(height, &blk).resulting_maze
      end

      # The necessary operations for one row are performed N times
      #
      # @param n [Fixnum] the number of steps to perform
      def step(n=10, &blk)
        (n-1).times do
          random_join
          yield resulting_maze if block_given?

          vertical_connections
          yield resulting_maze if block_given?
        end
        final_row
        yield resulting_maze if block_given?

        self
      end

      private

      # Step 1
      # Traverses the row from left to right pairwise,
      # randomly connecting adjacent cells of disjoint sets
      #
      # Appends the resulting row to the resulting maze
      def random_join
        union_disjoint_sets_carve_wall(skip_probability: [true, false] )
      end

      # Step 2
      # randomly reassigns cells and carves the walls between rows
      def vertical_connections
        resulting_maze << Maze.new(@size, 1)

        carved = (0...@size).group_by { |key| @uf.find(key) }.values.inject([]) do |changed, soc| # soc = set of cells
          soc.shuffle[0,1+rand(soc.size)].each do |cell|
            resulting_maze.carve_wall([cell,-1],[cell,-2])
            changed << cell
          end
          changed
        end

        ( (0...@size).to_a - carved ).each { |c| @uf.reassign(c) }

        self
      end

      # The final row has to be treated slightly different:
      # we have to connect ALL adjacent (but disjoint) cells.
      def final_row
        union_disjoint_sets_carve_wall(skip_probability: [false] )
      end

      # Iterates pairwise over an row and connects adjacent cells of disjoint
      # sets according to the given skip_probability
      #
      # Used as Step 1 and Step 3 as the final row is just as the all other rows,
      # with the difference that no cells are skipped.
      #
      # @param opt
      #   MUST have the key ':skip_probability' [Array<Boolean>]
      #
      # @return self
      def union_disjoint_sets_carve_wall(opt = { skip_probability: [true, false] } )
        (0...@size).each_cons(2) do |cell_1, cell_2|
          next if opt[:skip_probability].sample

          if @uf.find(cell_1) != @uf.find(cell_2)
            @uf.union(cell_1, cell_2)
            resulting_maze.carve_wall([cell_1,-1],[cell_2,-1])
          end
        end

        self
      end

    end
  end
end
