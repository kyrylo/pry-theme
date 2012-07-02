module PryTheme
  module Helper

    def each_theme_in(dir, &block)
      themes = Dir.entries(dir) - %w{ . .. }
      n = themes.size

      themes.each_with_index do |theme, index|
        yield(theme, index, n)
      end
    end

  end
end
