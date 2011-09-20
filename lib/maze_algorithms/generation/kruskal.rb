# This is the Kruskal Algorithm, used to generate MSTs.
# This version is randomized to generate perfect mazes
#
# The key point is to have a good datastructure to manage
# the disjoint sets of ervery cell.
#
# Steps:
#   - Generate a list of all edges
#   - randomly connect the edges if
#     the cells are in disjoint sets
#     and merge the sets
#
# Example:
#   +---+---+---+---+---+
#   | A | B | C | D | E |
#   +---+---+---+---+---+
#   | F | G | H | I | J |
#   +---+---+---+---+---+
#   | L | M | N | O | P |
#   +---+---+---+---+---+
#             v
#   +---+---+---+---+---+   +---+---+---+---+---+   +---+---+---+---+---+
#   | A   A | C | D | E |   | A   A | C | D | E |   | A   A | C | D | E |
#   +---+---+---+---+---+   +---+---+---+---+---+   +---+---+---+---+---+
#   | F | G | H | I | J | > | F | G | H | I | J | > | F | G | H | I | J | and on and on
#   +---+---+---+---+---+   +---+---+---+   +---+   +---+---+---+   +---+
#   | L | M | N | O | P |   | L | M | N | I | P |   | L   L | N | I | P |
#   +---+---+---+---+---+   +---+---+---+---+---+   +---+---+---+---+---+
#   Connect 0,0 with 0,1    Connect 3,1 with 3,2    Connect 0,2 with 1,2
#
module MazeAlgorithms
  class Kruskal

    # Central generate method, same for every algorithm
    #
    # @param width  [Fixnum]
    # @param height [Fixnum]
    #
    # @return [Maze] Returns the generated Maze
    def self.generate(width, height)
      cells = []
      (0...height).each do |y|
        (0...width).each do |x|
          cells << [x,y]
        end
      end

      union_find = UnionFind.new(cells)
      maze = Maze.new(width, height)
      edges = edge_list(maze).sort_by {rand}

      until edges.empty?
        edge = edges.pop
        from, to = *edge

        unless union_find.find(from) == union_find.find(to)
          maze.carve_wall(from, to)
          union_find.union(from, to)
        end

        yield maze if block_given?
      end

      maze
    end

    # Generates a list of all edges, by iterating
    # over the given maze
    #
    # @param maze [Maze] the maze to generate the list for
    # @return [Array<Array<Fixnum>,Array<Fixnum>>] The list of
    #   edges
    def self.edge_list(maze)
      maze.inject([]) do |mem, ary|
        cell, x, y = *ary

        mem << [[x,y],[x-1,y]] if x > 0
        mem << [[x,y],[x,y-1]] if y > 0

        mem
      end
    end

  end
end
