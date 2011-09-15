require_relative '../lib/maze_algorithms'
require 'benchmark'

include Benchmark
include MazeAlgorithms

bmbm(6) do |x|
  x.report("recursive_10x10") do
    1_000.times do
      MazeAlgorithms::RecursiveBacktracker.generate(10, 10)
    end
  end

  x.report("dfs_10x10") do
    1_000.times do
      MazeAlgorithms::DepthFirstSearch.generate(10, 10)
    end
  end

  x.report("ellers_10x10") do
    1_000.times do
      MazeAlgorithms::EllersAlgorithm.generate(10, 10)
    end
  end

  x.report("recursive_20x20") do
    1_000.times do
      MazeAlgorithms::RecursiveBacktracker.generate(20, 20)
    end
  end

  x.report("dfs_20x20") do
    1_000.times do
      MazeAlgorithms::DepthFirstSearch.generate(20, 20)
    end
  end

  x.report("ellers_20x20") do
    1_000.times do
      MazeAlgorithms::EllersAlgorithm.generate(20, 20)
    end
  end
end
