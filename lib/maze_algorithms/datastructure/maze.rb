module MazeAlgorithms
  module Datastructure
    class Maze
      include Enumerable
      attr_reader :width, :height
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
        @width, @height = width, height
        @path = []
        @grid = Array.new(@height) { Array.new(@width, 0) }
      end

      def directions
        MOVES.keys
      end

      # Given a start and dest point, carves the wall between them
      # Note: does NOT check the coords for performance
      # Example:
      #   carve_wall([3,3],[3,4]) # => nil
      def carve_wall(from, to)
        from_x, from_y = *from
        to_x, to_y     = *to

        direction = calc_dir(from, to)

        @grid[from_y][from_x] |= FLAGS[direction]
        @grid[to_y][to_x]     |= FLAGS[OPPOSITE[direction]]

        self
      end
      alias_method :connect, :carve_wall

      # Given two points, determines the necessary direction to get from the first to the second
      # from and two should be ARRAYS
      #
      # Example:
      #   calc_dir([0,0], [1,0]) # => :E
      #   calc_dir([5,5], [4,5]) # => :W
      def calc_dir(from, to)
        from_x, from_y = *from
        to_x, to_y     = *to

        if from_y == to_y
          return :E if from_x - to_x == -1
          return :W if from_x - to_x ==  1
        elsif from_x == to_x
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
        nx, ny = [x,y].zip(MOVES[direction]).map { |p| p.inject { |m,v| m+v } }
        return nx, ny if valid_coords?(nx, ny)
      end

      def valid_coords?(x, y)
        (x >= 0 && x < @width) && (y >= 0 && y < @height)
      end

      def visited?(x, y)
        @grid[y][x] != 0
      end

      def has_wall_between?(p1, p2)
        dir = calc_dir(p1, p2)

        from_p1 = @grid[p1[1]][p1[0]] & FLAGS[dir]
        from_p2 = @grid[p2[1]][p2[0]] & FLAGS[OPPOSITE[dir]]

        return from_p1 == 0 && from_p2 == 0
      end

      def neighbours(x, y)
        MOVES.keys.inject([]) { |mem,dir| mem << move_coords(x,y,dir) }.compact
      end

      def to_s
        result = ''
        result << "\n"
        @height.times do |y|
          @width.times do |x|
            result << '+' << ((@grid[y][x] & FLAGS[:N] == 0) ? '---' : '   ')
          end
          result << "+\n"
          @width.times do |x|
            if x == 0
              result << '|'
            else
              result << ((@grid[y][x] & FLAGS[:W] == 0) ? '|' : ' ')
            end
            result << (@path.include?([x,y]) ? ' * ' : '   ')
          end
          result << "|\n"
        end
        result << ('+---' * @width) + "+\n"
      end
      alias_method :to_str, :to_s

      def each_row &block
        raise "Give me a block" unless block_given?

        @grid.each do |row|
          yield(row)
        end
      end

      def get_row(y)
        return @grid[y]
      end

      def area
        @area ||= @width*@height
      end

      def [](x, y)
        x > 0 ? x : @width  + x
        y > 0 ? y : @height + y
        @grid[y][x]
      end

      def []=(x,y,value)
        x > 0 ? x : @width  + x
        y > 0 ? y : @height + y
        @grid[y][x] = value
      end

      def merge!(other_maze)
        raise ArgumentError, "Can only add another maze" unless other_maze.class == Maze
        raise ArgumentError, "The mazes must have the same width" unless other_maze.width == width

        other_maze.each_row do |row|
          @grid << row.clone
        end

        @height += other_maze.height

        self
      end
      alias_method :<<, :merge!

      def ==(other)
        return false if other.class != self.class
        return false if @width  != other.width
        return false if @height != other.height

        self.each do |cell, x, y|
          return false if (other[x,y] != cell)
        end

        true
      end

      def clone
        a_clone = self.class.new(@width, @height)
        self.each { |cell, x, y| a_clone[x,y] = cell }
        a_clone.path = @path.clone if @path

        a_clone
      end

      def each(&blk)
        (0...height).each do |y|
          (0...width).each do |x|
            yield(self[x,y], x, y)
          end
        end
      end
    end
  end
end
