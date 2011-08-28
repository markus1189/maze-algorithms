#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

require_relative 'maze.rb'
require_relative 'ellers_algorithm'
require 'set'

class MazeGenerator

  def self.generate(algorithm, width, height)
    maze = Maze.new(width, height)
    maze2 = Maze.new(width, height)

    case algorithm
    when /r(ecursive)?(_)?b(acktrack)?(ing)?/
      return "width or size too big for recursion!" if maze.area > 5000
      recursive_backtrack(maze)
    when /d(epth)?(_)?f(irst)?(_)?s(earch)?/
      depth_first_search(maze)
      depth_first_search(maze2)
    when /eller(s)?(_)?(algorithm)?/
      e = EllersAlgorithm.new(maze)
      e.generate
    else
      raise "Unknown algorithm: #{algorithm}"
    end

    return maze.merge! maze2
  end

  def self.recursive_backtrack(maze, cx=rand(maze.width), cy=rand(maze.height))
    directions = maze.directions
    directions.shuffle!

    directions.each do |direction|
      nx, ny = maze.move_coords(cx, cy, direction)

      next unless nx || ny

      if !maze.visited?(nx, ny)
        maze.carve_wall([cx, cy], [nx, ny])
        recursive_backtrack(maze, nx, ny)
      end
    end
  end
  class << self;
    alias_method :rb, :recursive_backtrack
  end

  def self.depth_first_search(maze)
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

  end
  class << self
    alias_method :dfs, :depth_first_search
  end
end
