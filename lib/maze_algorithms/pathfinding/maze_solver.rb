#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

require 'algorithms'

module MazeAlgorithms
  class MazeSolver
    include Containers

    def self.solve(maze, start = [0,0], target = [maze.width-1, maze.height-1])
      preds = { start => [nil, 0] } # element => predecessor, distance
      visited = Hash.new
      queue = PriorityQueue.new { |x, y| (x <=> y) == -1 }

      queue.push(start, 0)

      until queue.empty?
        curr = queue.pop
        visited[curr] = true
        dist = preds[curr][1] + 1

        nbs = []
        maze.directions.each do |direction|
          coords = maze.move_coords(*curr, direction)
          nbs << coords if coords && !visited[coords] && !maze.has_wall_between?(curr, coords)
        end

        nbs.each do |nb|
          unless preds[nb] && preds[nb][1] < dist
            preds[nb] = [curr, dist]
            queue.push(nb, dist)
          end
        end

      end

      maze.path = generate_path(preds, target)
      maze
    end

    private

    def self.generate_path(preds, target)
      path = [target]

      curr = target
      while pred=preds[curr][0]
        path.unshift(pred)
        curr = pred
      end
      path
    end
  end
end
