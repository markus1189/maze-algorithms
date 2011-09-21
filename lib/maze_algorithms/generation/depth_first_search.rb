module MazeAlgorithms
  module Generation
    class DepthFirstSearch
      def self.generate(width, height, &blk)
        maze = Maze.new(width, height)
        stack = [[rand(width),rand(height)]]
        until stack.empty?
          current = stack.last

          nbs = maze.neighbours(*current).reject { |nb| maze.visited?(*nb) }

          if nbs.empty?
            stack.pop
          else
            rnd_neighbour = nbs.sample
            maze.carve_wall(current, rnd_neighbour)

            stack.pop if nbs.size==1
            stack.push rnd_neighbour
          end

          yield maze if block_given?
        end

        maze
      end
    end
  end
end
