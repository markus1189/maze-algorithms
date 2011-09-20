require_relative '../lib/maze_algorithms'
require 'benchmark'

include Benchmark
include MazeAlgorithms

bmbm(6) do |x|
  @maze = Maze.new(100,100)
  x.report("carve_wall") do
    100_000.times do
      x = rand(98)
      y = rand(98)
      @maze.carve_wall([x,y],[x+1,y])
    end
  end

end
