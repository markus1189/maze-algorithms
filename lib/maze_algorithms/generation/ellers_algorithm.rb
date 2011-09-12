module MazeAlgorithms
  class EllersAlgorithm
    attr_reader :set

    def initialize(maze)
      @row = (1..maze.width).to_a
      @union_find = UnionFind.new(@row)
      @maze = maze
    end

    def random_join
      @row.each_cons(2) do |cell_1, cell_2|
        next unless coin(true,false,false)

        if not @union_find.same_set?(cell_1,cell_2) && coin

        end
      end
    end

    def coin(*args=[true,false])
      args.sample
    end
  end
end
