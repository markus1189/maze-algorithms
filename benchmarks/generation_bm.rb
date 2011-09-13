require_relative '../lib/maze_algorithms'
require 'benchmark'

include Benchmark
include MazeAlgorithms

bmbm(6) do |x|
  x.report("recursive_10x10") do
    @maze = Maze.new(10,10)
    1_000.times do
      MazeAlgorithms::RecursiveBacktracker.generate(@maze)
    end
  end

  x.report("dfs_10x10") do
    @maze = Maze.new(10,10)
    1_000.times do
      MazeAlgorithms::DepthFirstSearch.generate(@maze)
    end
  end

  x.report("ellers_10x10") do
    @maze = Maze.new(10,10)
    1_000.times do
      MazeAlgorithms::EllersAlgorithm.generate(@maze)
    end
  end

  x.report("recursive_20x20") do
    @maze = Maze.new(20,20)
    1_000.times do
      MazeAlgorithms::RecursiveBacktracker.generate(@maze)
    end
  end

  x.report("dfs_20x20") do
    @maze = Maze.new(20,20)
    1_000.times do
      MazeAlgorithms::DepthFirstSearch.generate(@maze)
    end
  end

  x.report("ellers_20x20") do
    @maze = Maze.new(20,20)
    1_000.times do
      MazeAlgorithms::EllersAlgorithm.generate(@maze)
    end
  end
end
