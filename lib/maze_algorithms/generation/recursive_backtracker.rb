module MazeAlgorithms
  class RecursiveBacktracker
    def self.generate(width, height,
                      cx=rand(width), cy=rand(height))
      maze = Maze.new(width, height)
      directions = maze.directions
      directions.shuffle!

      directions.each do |direction|
        nx, ny = maze.move_coords(cx, cy, direction)

        next unless nx || ny

        if !maze.visited?(nx, ny)
          maze.carve_wall([cx, cy], [nx, ny])
          generate(maze, nx, ny)
        end
      end

      maze
    end
  end
end
