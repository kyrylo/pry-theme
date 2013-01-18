module PryTheme
  class Color256 < PryTheme::Color

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

    def find_from_fixnum(color_id)
      found_color = colors.find { |_, *term| term.flatten.include?(color_id) }
      found_color.first if found_color
    end

  end
end
