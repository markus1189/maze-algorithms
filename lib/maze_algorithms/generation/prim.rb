module MazeAlgorithms

  class Prim
    def self.generate(width, height, &blk)
      maze = Maze.new(width, height)

      start = [rand(width),rand(height)]
      nbs = Set.new(maze.neighbours(*start))

      step = nbs.sample
      nbs.delete step

      maze.carve_wall(start, step)

      until nbs.empty?
        current = nbs.sample
        nbs.delete current

        adjacent = maze.neighbours(*current).group_by { |c| maze.visited?(*c) }

        maze.carve_wall(current, adjacent[true].sample) # connect to already visited

        nbs.merge(adjacent[false]) if adjacent[false]

        yield maze if block_given?
      end

      maze
    end

  end

end
