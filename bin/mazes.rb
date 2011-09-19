#!/usr/bin/env ruby

require_relative '../lib/maze_algorithms'
require 'optparse'

include MazeAlgorithms

opt = {
  algo: :eller,
  width: 20,
  height: 20,
  solve: false,
  seed: "#{rand(0xFFFF_FFFF)}",
  visual: false,
  delay: 0
}

OptionParser.new do |opts|
  opts.banner = "Can be used to generate mazes with specific algorithms"

  opts.on('-a', '--algorithm ALGORITHM',
          "Choose the algorithm used for the maze (Default: Kruskal") do |algo|
    opt[:algo] = algo.downcase.to_sym
  end

  opts.on('-s', '--size WIDTHxHEIGHT',
          "The size of the maze, note the 'x' between WIDTH and HEIGHT") do |size|
    width, height    = size.split('x')
    opt[:width]  = width.to_i
    opt[:height] = height.to_i
  end

  opts.on('-e', '--seed SEED',
          "The seed for the maze for reconstruction") do |seed|
    opt[:seed] = seed
  end

  opts.on('-p', '--show--path FROM,TO',
          "Find the path from FROM to TO, where each is a pair of coordinates.
         Example: FROM=0,0 TO=10,10 => --show-path 0,0,10,10") do |from_to|
    x,y,nx,ny = from_to.split(',').map!(&:to_i)
    opt[:solve] = [[x,y],[nx,ny]]
  end

  opts.on('-v', '--visual', "Display the generation progress") do |delay|
    opt[:visual] = true
  end

  opts.on('-d', '--delay N', "Sleep N ms between steps") do |delay|
    opt[:delay] = delay.to_f
  end

  opts.on_tail("-?", "-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

# ------------------------------------------------------------------------------

conv_seed = opt[:seed].each_char.inject(0) { |mem, var| mem * var.ord+1 }
srand(conv_seed)

algorithms = {
  :kruskal => Kruskal,
  :eller   => EllersAlgorithm,
  :dfs     => DepthFirstSearch,
  :rec     => RecursiveBacktracker,
  :prim    => Prim
}

print "\e[2J" # clear the screen

visualizer = lambda { |maze| print "\e[H"; p maze if opt[:visual]; sleep(opt[:delay]) } #executed for every step
maze = algorithms[opt[:algo]].generate(opt[:width], opt[:height], &visualizer)
maze = MazeSolver.solve(maze, *opt[:solve]) if opt[:solve]

p maze unless opt[:visual]

puts "Algorithm: #{algorithms[opt[:algo]]}, Size: #{opt[:width]}x#{opt[:height]}, Seed: #{opt[:seed]}"
