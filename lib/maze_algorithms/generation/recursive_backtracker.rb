module MazeAlgorithms
  module Generation
    class RecursiveBacktracker
      def self.generate(width, height,
                        cx=rand(width), cy=rand(height),
                        maze=nil, &blk)
        maze = Maze.new(width, height) unless maze
        directions = maze.directions
        directions.shuffle!

        directions.each do |direction|
          nx, ny = maze.move_coords(cx, cy, direction)

          next unless nx || ny

          if !maze.visited?(nx, ny)
            maze.carve_wall([cx, cy], [nx, ny])

            yield maze if block_given?

            generate(width, height, nx, ny, maze, &blk)
          end
        end


        maze
      end
    end
  end
end
