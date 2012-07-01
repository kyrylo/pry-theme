module PryTheme
  module Helper

    def each_theme_in(dir, &block)
      (Dir.entries(dir) - %w{ . .. }).each do |file|
        yield(file)
      end
    end

  end
end
