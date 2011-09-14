#!/usr/bin/env ruby

require_relative '../lib/maze_algorithms'

include MazeAlgorithms

width  = (ARGV[0] || 20).to_i
height = (ARGV[1] || 80).to_i
solve  = (ARGV[2] || true)
seed   = (ARGV[3] || rand(0xFFFF_FFFF)).to_i

srand(seed)

puts MazeSolver.solve(EllersAlgorithm.generate(width, height))

puts "Seed: #{seed}"
