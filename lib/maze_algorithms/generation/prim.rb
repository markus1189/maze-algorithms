module MazeAlgorithms

  class Prim

    def self.generate(width, height, &blk)
      maze = Maze.new(width, height)

      #start = [rand(width),rand(height)]
      start = [0,0]
      nbs = maze.neighbours(*start)

      maze.carve_wall(start, nbs.delete_at(rand(nbs.size)))

      until nbs.empty?
        current = nbs.delete_at(rand(nbs.size))

        adjacent = maze.neighbours(*current).group_by { |c| maze.visited?(*c) }

        maze.carve_wall(current, adjacent[true].sample) # connect to already visited

        nbs = nbs | adjacent[false] if adjacent[false]

        yield maze if block_given?
      end

      maze
    end

  end

end
