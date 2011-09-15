#!/usr/bin/env ruby

require_relative '../lib/maze_algorithms'

include MazeAlgorithms

width  = (ARGV[0] || 20).to_i
height = (ARGV[1] || 10).to_i
solve  = (ARGV[2] == "true") ? true : false
seed   = (ARGV[3] || rand(0xFFFF_FFFF))

if seed.class == String
  conv_seed = seed.each_char.inject(0) { |mem, var| mem + var.ord }
else
  conv_seed = seed
end

srand(conv_seed)

#maze = EllersAlgorithm.generate(width, height)
require 'pp'
maze = Kruskal.generate(width, height)

maze =  MazeSolver.solve(maze) if solve

pp maze
puts "Size: #{width}x#{height}, Seed: #{seed}"
