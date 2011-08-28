#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

require_relative 'maze_generator'
require_relative 'maze_solver'

algorithm = (ARGV[0] || "dfs").to_sym
width     = (ARGV[1] || "50").to_i
height    = (ARGV[2] || "10").to_i
start     = (ARGV[3] ? ARGV[3].split(',').map! { |c| c.to_i} : [0,0])
target    = (ARGV[4] ? ARGV[4].split(',').map! { |c| c.to_i} : [width-1,height-1])

maze = MazeGenerator.generate(algorithm, width, height)
puts MazeSolver.solve(maze,start,target)

puts ("Parameters:\n" +
     "Size: #{width}x#{height}\n" +
     "Algorithm: #{algorithm}")
