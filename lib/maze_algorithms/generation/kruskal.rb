module MazeAlgorithms
  class Kruskal

    def self.generate(width, height)
      maze = Maze.new(width, height)
      edges = edge_list.sort_by {rand}

      #TODO intialize UnionFind

      until edges.empty?
        x, y, nx, ny = edges.pop.flatten

        flag_from, flag_to = calc_dir(x,y,nx,y)

      end

    end

    def self.edge_list(maze)
      maze.inject([]) do |mem, ary|
        cell, x, y = *ary

        mem << [[x,y],[x-1,y]] if x > 0
        mem << [[x,y],[x,y-1]] if y > 0

        mem
      end
    end

    def self.calc_dir(x, y, nx, ny)
      dir = :N if x == nx && y-ny == 1
      dir = :W if x-nx == 1 && y == ny

      return Maze::FLAGS[dir], Maze::FLAGS[Maze::OPPOSITE[dir]]
    end


  end
end
