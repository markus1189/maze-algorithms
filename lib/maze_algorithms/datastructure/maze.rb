module MazeAlgorithms
  module Datastructure
    class Maze
      include Enumerable
      attr_reader :width, :height
      attr_accessor :special_fields

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

      def initialize(width, height, walls=:with_walls)
        @width, @height = width, height
        @special_fields = {}

        wall_val = case walls
        when :with_walls then 0
        when :without_walls then FLAGS.values.inject(:|)
        else raise ArgumentError, "walls has to be in [:all, :none], given: #{walls}"
        end

        @grid = Array.new(@height) { Array.new(@width, wall_val) }
      end

      def directions
        MOVES.keys
      end

      # Given a start and dest point, carves the wall between them
      # Note: does NOT check the coords for performance
      # Example:
      #   carve_wall([3,3],[3,4]) # => nil
      def carve_wall(from, to)
        direction = calc_dir(from, to)

        from_x, from_y = *from
        to_x, to_y     = *to

        self[from_x, from_y] |= FLAGS[direction]
        self[to_x, to_y]     |= FLAGS[OPPOSITE[direction]]

        self
      end
      alias_method :connect, :carve_wall

      def add_wall(from, to)
        direction = calc_dir(from, to)

        from_x, from_y = *from
        to_x, to_y     = *to

        self[from_x, from_y] ^= FLAGS[direction]
        self[to_x, to_y]     ^= FLAGS[OPPOSITE[direction]]

        self
      end
      alias_method :disconnect, :add_wall

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
        case direction
        when :N then nx = x   ; ny = y-1
        when :S then nx = x   ; ny = y+1
        when :W then nx = x-1 ; ny = y
        when :E then nx = x+1 ; ny = y
        else raise "unknown direction: #{direction}"
        end

        return nx, ny if valid_coord?(nx, ny)
      end

      def valid_coord?(x,y)
        (x >= 0 && x < @width) && (y >= 0 && y < @height)
      end

      def visited?(x, y)
        not self[x,y].zero?
      end

      # Test if every cell is reachable
      # (simple bfs)
      def solvable?
        start = [@width/2, @height/2]
        visited = Set.new([start])
        queue = [start]

        until queue.empty?
          current = queue.pop
          neighbours(*current).reject do |nb|
            has_wall_between?(current, nb)
          end.each do |nb|
            queue << nb unless visited.include? nb
            visited << nb
          end
        end

        visited.size == @width*@height
      end

      def has_wall_between?(p1, p2)
        dir = calc_dir(p1, p2)

        has_wall_at?(*p1, dir) && has_wall_at?(*p2, OPPOSITE[dir])
      end

      def has_wall_at?(x,y,dir)
        (self[x,y] & FLAGS[dir]).zero?
      end

      def neighbours(x, y, &blk)
        MOVES.keys.inject([]) { |mem,dir| mem << move_coords(x,y,dir) }.compact
      end

      def to_s
        result = ''
        result << "\n"

        @height.times do |y|
          @width.times do |x|
            result << '+' << ((has_wall_at?(x,y,:N) || y == 0) ? '---' : '   ')
          end
          result << "+\n"
          @width.times do |x|
            result << ((has_wall_at?(x,y,:W) || x == 0) ? '|' : ' ')
            result << (@special_fields[[x,y]] ? " #{@special_fields[:symbol]} " : '   ')
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

      def [](x, y)
        @grid[y][x]
      end

      def []=(x, y, value)
        @grid[y][x] = value
      end

      def merge!(other_maze)
        raise ArgumentError, "Can only add another maze" unless other_maze.class == Maze
        raise ArgumentError, "The mazes must have the same width" unless other_maze.width == width

        other_maze.each_row { |row| @grid << row.clone }

        @height += other_maze.height

        self
      end
      alias_method :<<, :merge!

      def ==(other)
        result = other.class == self.class
        result &&= @width == other.width
        result &&= @height == other.height
        result &&= self.all? { |cell, x, y| other[x,y] == cell }

        result
      end

      def dup
        sibling = self.class.new(@width, @height)
        instance_variables.each do |ivar|
          value = self.instance_variable_get(ivar)
          new_value = value.clone rescue value
          sibling.instance_variable_set(ivar, new_value)
        end
        sibling.taint if tainted?

        sibling
      end

      def clone
        sibling = dup
        sibling.freeze if frozen?

        sibling
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
