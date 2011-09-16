#!/usr/bin/env ruby

require_relative '../lib/maze_algorithms'

include MazeAlgorithms

algo   = (ARGV[0] || "kruskal").to_sym
width  = (ARGV[1] || 20).to_i
height = (ARGV[2] || 10).to_i
solve  = (ARGV[3] == "true") ? true : false
seed   = (ARGV[4] || "#{rand(0xFFFF_FFFF)}")

conv_seed = seed.each_char.inject(0) { |mem, var| mem + var.ord }
srand(conv_seed)

algorithms = {
  :kruskal => Kruskal,
  :eller   => EllersAlgorithm,
  :dfs     => DepthFirstSearch,
  :rec     => RecursiveBacktracker
}

maze = algorithms[algo].generate(width, height)
maze = MazeSolver.solve(maze) if solve

p maze
puts "Algorithm: #{algo}, Size: #{width}x#{height}, Seed: #{seed}"
