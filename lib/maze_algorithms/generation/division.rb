module MazeAlgorithms
  module Generation
    class Division

      def self.generate(width, heigt)
        maze = Maze.new(width, height)

        all_flags = Maze::FLAGS.keys.inject(:+)

        maze.map! { all_flags }

        maze
      end

      def self.orientation(width, heigth)
        if width < height
          :horizontal
        elsif width > height
          :vertical
        else
          [:horizontal,:vertical].sample
        end
      end

    end
  end
end
