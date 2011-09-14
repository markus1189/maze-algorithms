module MazeAlgorithms
  class DepthFirstSearch
    def self.generate(width, height)
      maze = Maze.new(width, heigt)
      stack = [[0,0]]
      until stack.empty?
        current = stack.last

        nbs = []
        maze.directions.each do |direction|
          coords = maze.move_coords(*current, direction)
          nbs << coords unless maze.visited?(*coords) if coords
        end

        if nbs.empty?
          stack.pop
        else
          rnd_neighbour = nbs.sample
          maze.carve_wall(current, rnd_neighbour)

          stack.pop if nbs.size==1
          stack.push rnd_neighbour
        end
      end

      maze
    end
  end
end
