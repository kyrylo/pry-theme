module PryTheme
  class Color256 < PryTheme::Color

    include Formattable

    def initialize(options = {})
      super(256, options)
    end

    private

    def create_ansi_sequence(fg, bg)
      super(fg, bg, '0')
    end

    def build_fg_sequence
      ['38', '5', foreground]
    end

    def build_bg_sequence
      ['48', '5', background]
    end

    def find_from_integer(color_id)
      pair = colors.find { |*term| term.first.flatten.include?(color_id) }
      pair.first if pair
    end

  end
end
