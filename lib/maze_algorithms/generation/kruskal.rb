module MazeAlgorithms
  class Kruskal

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

        unless union_find.same_set?(from, to)
          maze.carve_wall(from, to)
          union_find.union(from, to)
        end

        yield maze if block_given?
      end

      maze
    end

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
