#!/usr/bin/env ruby

require_relative '../lib/maze_algorithms'
require 'optparse'

include MazeAlgorithms

options = {
  gen_algo: :kruskal,
  width: 20,
  height: 20,
  solve: false,
  seed: "#{rand(0xFFFF_FFFF)}"
}

OptionParser.new do |opts|
  opts.banner = "Can be used to generate mazes with specific algorithms"

  opts.on('-a', '--algorithm ALGORITHM',
          "Choose the algorithm used for the maze (Default: Kruskal") do |algo|
    options[:gen_algo] = algo.downcase.to_sym
          end

  opts.on('-s', '--size WIDTHxHEIGHT',
          "The size of the maze, note the 'x' between WIDTH and HEIGHT") do |size|
    width, height    = size.split('x')
    options[:width]  = width.to_i
    options[:height] = height.to_i
          end

  opts.on('-e', '--seed SEED',
          "The seed for the maze for reconstruction") do |seed|
    options[:seed] = seed
          end

  opts.on('-p', '--show--path FROM,TO',
          "Find the path from FROM to TO, where each is a pair of coordinates.
         Example: FROM=0,0 TO=10,10 => --show-path 0,0,10,10") do |from_to|
    x,y,nx,ny = from_to.split(',').map!(&:to_i)
    options[:solve] = [[x,y],[nx,ny]]
         end

  opts.on_tail("-?", "-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

# ------------------------------------------------------------------------------

algo   = options[:gen_algo]
width  = options[:width]
height = options[:height]
solve  = options[:solve]
seed   = options[:seed]

conv_seed = seed.each_char.inject(0) { |mem, var| mem * var.ord } % 21013
srand(conv_seed)

algorithms = {
  :kruskal => Kruskal,
  :eller   => EllersAlgorithm,
  :dfs     => DepthFirstSearch,
  :rec     => RecursiveBacktracker
}

maze = algorithms[algo].generate(width, height)
maze = MazeSolver.solve(maze, *solve) if options[:solve]

p maze
puts "Algorithm: #{algo}, Size: #{width}x#{height}, Seed: #{seed}"
