#!/usr/bin/env ruby -wKU
# Author: markus1189@gmail.com

class Maze
  attr_reader :width, :height, :directions
  attr_accessor :path

  FLAGS = {
    :N => 1,
    :S => 2,
    :W => 4,
    :E => 8
  }

  MOVES = {
    :N => [ 0,-1],
    :S => [ 0, 1],
    :E => [ 1, 0],
    :W => [-1, 0]
  }

  OPPOSITE = {
    :N => :S,
    :S => :N,
    :W => :E,
    :E => :W
  }

  def initialize(width, height)
    @width      = width
    @height     = height
    @directions = MOVES.keys

    @path = nil

    @grid = Array.new(@height) { Array.new(@width, 0) }
  end

  # Given a start and dest point, carves the wall between them
  # Example:
  #   carve_wall([3,3],[3,4]) # => nil
  def carve_wall(from, to)
    from_x, from_y = *from
    to_x, to_y     = *to

    check_points(from, to)

    direction = calc_dir(from, to)

    @grid[from_y][from_x] |= FLAGS[direction]
    @grid[to_y][to_x]     |= FLAGS[OPPOSITE[direction]]

    nil
  end

  # Given two points, determines the necessary direction to get from the first to the second
  # from and two should be ARRAYS
  #
  # Example:
  #   calc_dir([0,0], [1,0]) # => :E
  #   calc_dir([5,5], [4,5]) # => :W
  def calc_dir(from, to)
    from_x, from_y = *from
    to_x, to_y     = *to

    check_points(from, to)

    if from_y == to_y
      return :E if from_x - to_x == -1
      return :W if from_x - to_x ==  1
    end
    if from_x == to_x
      return :S if from_y - to_y == -1
      return :N if from_y - to_y ==  1
    end
  end

  # Given an x- and y-coordinate,
  # returns the transformed x, y when moving towards the given direction
  #
  # Example:
  #   move_coords(5,5, :N) # => [5,4]
  #   move_coords(3,4, :E) # => [4,4]
  #   move_coords(2,1, :S) # => [2,2]
  def move_coords(x, y, direction)
    dx, dy = MOVES[direction] # get the moving coords
    dx, dy = dx+x, dy+y       # add from coords to moving

    return dx, dy if valid_coords?(dx, dy)
  end

  def valid_coords?(x, y)
    (0...@width) === x && (0...@height) === y
  end

  def visited?(x, y)
    @grid[y][x] != 0
  end

  def has_wall_between?(p1, p2)
    check_points(p1, p2)

    dir = calc_dir(p1, p2)

    from_p1 = @grid[p1[1]][p1[0]] & FLAGS[dir]
    from_p2 = @grid[p2[1]][p2[0]] & FLAGS[OPPOSITE[dir]]

    return from_p1 == 0 && from_p2 == 0
  end

  def to_s
    result = ''
    @height.times do |y|
      @width.times do |x|
        result << "+" << ((@grid[y][x] & FLAGS[:N] == 0) ? "---" : "   ")
      end
      result << "+\n"
      @width.times do |x|
        if x == 0
          result << "|"
        else
          result << ((@grid[y][x] & FLAGS[:W] == 0) ? "|" : " ")
        end
        if @path
          result << (@path.include?([x,y]) ? " * " : "   ")
        else
          result << "   "
        end
      end
      result << "|\n"
    end
    result << ("+---" * @width) + "+\n"
  end
  alias_method :to_str, :to_s

  # Checks the given points:
  #   - whether they are out of bounds
  #   - whether they are adjacent
  #
  # Example:
  #   check_points([0,0], [0,1])  # => okay
  #   check_points([0,0], [0,2])  # => Error (not adjacent)
  #   check_points([0,-1], [0,0]) # => Error (out of bounds)
  def check_points(from, to)
    from_x, from_y = *from
    to_x, to_y     = *to

    raise "Invalid coords: #{from}" unless valid_coords?(*from)
    raise "Invalid coords: #{to}"   unless valid_coords?(*to)

    raise "Points have to be adjacent" unless (-1..1) === (from_x - to_x + from_y - to_y)
  end

  def area
    @width*@height
  end

  def [](x, y)
    @grid[y][x]
  end

end
