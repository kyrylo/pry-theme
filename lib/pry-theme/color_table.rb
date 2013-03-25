module PryTheme
  class ColorTable

    class << self
      def t256
        ColorTable.new(256).table
      end

      def t16
        ColorTable.new(16).table
      end

      def t8
        ColorTable.new(8).table
      end

      def build_color_string(color, fg = nil)
        "\e[7;%sm%s\e[0m:\e[%sm%s\e[0m" %
          [color.to_ansi, fg || color.foreground,
           color.to_ansi, color.foreground(true)]
      end
    end

    def initialize(color_model)
      @color_model = color_model
    end

    def table
      colors = []
      0.upto(@color_model - 1) { |i|
        color = PryTheme.const_get(:"Color#@color_model").new(
          :from => :term, :foreground => i)
        colors << self.class.build_color_string(color, i)
      }
      Pry::Helpers.tablify_or_one_line("Color model #@color_model", colors)
    end

  end
end
