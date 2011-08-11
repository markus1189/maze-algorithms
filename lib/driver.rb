#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

require_relative 'maze'
require_relative 'maze_generator'
require_relative 'maze_solver'

algorithm = (ARGV[0] || "dfs").to_sym
width     = (ARGV[1] || "50").to_i
height    = (ARGV[2] || "10").to_i

maze = MazeGenerator.generate(algorithm, Maze.new(width, height))
puts MazeSolver.solve(maze)

puts ("Parameters:\n" +
     "Size: #{width}x#{height}\n" +
     "Algorithm: #{algorithm}")
