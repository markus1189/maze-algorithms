#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

require 'ap'
require 'set'

required_files = <<EOS
maze_algorithms/datastructure/cell
maze_algorithms/datastructure/maze
maze_algorithms/datastructure/union_find

maze_algorithms/generation/depth_first_search
maze_algorithms/generation/recursive_backtracker
maze_algorithms/generation/ellers_algorithm
maze_algorithms/generation/kruskal
maze_algorithms/generation/prim
maze_algorithms/generation/division

maze_algorithms/pathfinding/maze_solver

../extensions/set.rb
EOS

required_files.each_line do |line|
  line.chomp!
  next if line.empty?
  require_relative line
end

include MazeAlgorithms
include Datastructure
include Generation
