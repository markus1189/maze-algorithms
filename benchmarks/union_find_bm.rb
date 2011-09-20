require_relative '../lib/maze_algorithms'
require 'benchmark'

include Benchmark
include MazeAlgorithms

keys = (0..100_000).to_a

bmbm(7) do |x|
  x.report(UnionFind.to_s) do
    u = UnionFind.new(keys)
    keys.each_cons(2) do |one, two|
      u.union(one,two)
    end
  end
end
