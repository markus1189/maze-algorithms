require_relative '../lib/maze_algorithms'
require 'benchmark'

include Benchmark
include MazeAlgorithms

algorithms = [
  RecursiveBacktracker,
  DepthFirstSearch,
  EllersAlgorithm,
  Kruskal,
  Prim
]

bmbm(6) do |x|
  algorithms.each do |algo|
    x.report(algo.to_s + " 10x10") do
      100.times do
        algo.generate(10,10)
      end
    end

    x.report(algo.to_s + " 20x20") do
      100.times do
        algo.generate(20,20)
      end
    end
  end
end
