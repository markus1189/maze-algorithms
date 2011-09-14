#!/usr/bin/env ruby

require_relative '../lib/maze_algorithms'

include MazeAlgorithms

width  = (ARGV[0] || 20).to_i
height = (ARGV[1] || 80).to_i
solve  = (ARGV[2] == "false") ? false : true
seed   = (ARGV[3] || rand(0xFFFF_FFFF))

if seed.class == String
  conv_seed = seed.each_char.inject(0) { |mem, var| mem + var.ord }
end

srand(conv_seed)

maze = EllersAlgorithm.generate(width, height)

maze = EllersAlgorithm.generate(width, height)
3.times do
  maze << EllersAlgorithm.generate(width, height)
end

maze =  MazeSolver.solve(maze) if solve

puts maze

puts "Seed: #{seed}"
