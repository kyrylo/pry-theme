module PryTheme
  class Color8 < Color

    def initialize(options = {})
      super(8, options)
    end

    private

    def create_ansi_sequence(fg, bg)
      super(fg, bg, '39;49')
    end

    def build_fg_sequence
      [foreground]
    end

    def build_bg_sequence
      [background]
    end

    def find_from_fixnum(color_id)
      colors.each_with_index.to_a.rassoc(color_id).first.first
    end

    def build_effects_sequence
      []
    end

  end
end
