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
        x, y, nx, ny = edges.pop.flatten

        flag_from, flag_to = calc_dir(x,y,nx,ny)

        unless union_find.same_set?([x,y],[nx,ny])
          maze[x,y] = maze[x,y] | flag_from
          maze[nx,ny] |= flag_to
          union_find.union([x,y],[nx,ny])
        end

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

    def self.calc_dir(x, y, nx, ny)
      if x == nx && y-ny == 1
        dir = :N
      elsif x-nx == 1 && y == ny
        dir = :W
      else
        raise "neither #{x} == #{nx} && #{y}-#{ny} nor #{x}-#{nx} && #{y}==#{ny}"
      end

      return Maze::FLAGS[dir], Maze::FLAGS[Maze::OPPOSITE[dir]]
    end

  end
end
