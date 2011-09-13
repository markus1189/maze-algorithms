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
#    +   +---+   +   +---+   +   Randomly create vertical conncetions, at least one per set
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
  class EllersAlgorithm
    def initialize(maze)
      @row = Maze.new(maze.width, 1)
      @union_find = UnionFind.new(0...maze.width)
      @maze = maze
    end

    def step
      join_adjacent
      vertical_connections
      assign_missing
    end

    def random_join
      (0...@row.width).each_cons(2) do |cell_1, cell_2|
        next unless coin(true,false,false)

        if not @union_find.same_set?(cell_1,cell_2)
          @union_find.union(cell_1, cell_2)
          @row.carve_wall([cell_1,0],[cell_2,0])
        end

      end
      @row
    end

    def coin(*args)
      args.sample
    end
  end
end
