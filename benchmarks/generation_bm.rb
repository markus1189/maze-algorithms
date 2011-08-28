require_relative '../lib/maze_algorithms'
require 'benchmark'

include Benchmark

bmbm(6) do |x|
  x.report("recursive_20x20") do
    @maze = Maze.new(20,20)
    100.times do
      MazeGeneration::RecursiveBacktracker.generate(@maze)
    end
  end

  x.report("dfs_20x20") do
    @maze = Maze.new(20,20)
    100.times do
      MazeGeneration::DepthFirstSearch.generate(@maze)
    end
  end

  x.report("ellers_20x20") do
    @maze = Maze.new(20,20)
    100.times do
      @algo = MazeGeneration::EllersAlgorithm.new(@maze)
      @algo.generate
    end
  end
end
