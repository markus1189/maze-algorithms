#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

class Cell
  def initialize
    @state = 0
  end

  # Define the methods north!, north?, south! ...
  # for each direction in north, south, east, west
  # <dir>! sets the flag for the <dir> wall
  # <dir>? returns whether there is a wall at <dir>
  # Example:
  #   north! # =>   wall set at north
  #   south! # =>   wall set at south
  #
  #   north? # =>   true
  #   south? # =>   true
  #
  #   west?  # =>   false
  %w{north south west east}.each_with_index do |direction, i|
    define_method((direction + '!').to_sym) do
      @state |= 2**i
    end

    define_method((direction + '?').to_sym) do
      (@state & 2**i) > 0
    end
  end
end
