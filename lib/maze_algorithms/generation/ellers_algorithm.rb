#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

require 'set'
require 'pp'

class Array
  def count_block_size(start, obj)
    block_size = 0

    return block_size if self[start] != obj

    offset = start
    while offset >= 0 && self[offset] == obj
      block_size += 1
      offset -= 1
    end

    offset = start+1
    while offset < self.size && self[offset] == obj
      block_size += 1
      offset += 1
    end

    block_size
  end
end

class EllersAlgorithm
  attr_reader :set

  def initialize(maze)
    @maze = maze
    @set = Array.new(maze.width)
     assign_missing(@set)
  end

  def generate
    (@maze.height-1).times do |y|
      random_join(@maze.get_row(y), y)
      vertical_connections(y)
      assign_missing(@set)
    end
    #Last row
    join_adjacent_disjoint(@maze.get_row(@maze.height-1))
  end

  def assign_missing(set)
    last_index = set.compact.max || -1

    set.map! do |entry|
      unless entry then last_index +=1
      else entry
      end
    end

    @set = set
  end

  def random_join(row, y)
    (0...row.size).each do |x|
      new_x = x + coin(1, -1) # randomly choose left of right
      if valid_different_sets_and_coin(new_x, x)
        @maze.carve_wall([x,y], [new_x,y])

        ##################### Make sure all set indexes are changed
        x1 = x
        x2 = new_x
        direction = x1 < x2 ? 1 : -1
        until x2 < 0 || x2 > row.size-1 ||  @maze.has_wall_between?([x1,y],[x2,y])
          @set[x2] = @set[x1]
          x1 += direction
          x2 += direction
        end
        #####################
      end
    end
  end

  def join_adjacent_disjoint(row)
    y = @maze.height-1
    (0...row.size-1).each do |x| # yes, exclude the two last
      if @set[x] != @set[x+1]
        @maze.carve_wall([x,y],[x+1,y])
      end
    end
  end

  # Throws a 'true/false'-coin and if true
  # Checks:
  #   - if new_x is valid index for maze
  #   - if both coords have a different set number
  #
  # Used by random_join
  def valid_different_sets_and_coin(new_x, x)
    coin(true, false) &&
      (0...@maze.width) === new_x &&
      @set[new_x] != @set[x]
  end

  def vertical_connections(y)
    old_set = @set
    new_set = Array.new(old_set.size)
    offset = 0

    while offset < old_set.size
      cells_in_set = old_set.count_block_size(offset, old_set[offset])
      carved_walls = 0


      cells_in_set.times do |x|
        puts "trouble ahead" if offset+x >= old_set.size
        if cells_in_set == 1 || coin(true, false)
          @maze.carve_wall([offset+x,y],[offset+x,y+1])
          new_set[offset+x] = old_set[offset+x]
          carved_walls += 1
        end
        if x == cells_in_set-1 && carved_walls == 0
          @maze.carve_wall([offset+x,y],[offset+x,y+1])
          new_set[offset+x] = old_set[offset+x]
        end
      end

      offset += cells_in_set
    end

    @set = new_set
  end

  def coin(*args)
    args.sample
  end
end

if $0  == __FILE__
  require_relative 'maze'
  maze = Maze.new(15,15)
  e = EllersAlgorithm.new(maze)
  e.generate
  p maze
end
