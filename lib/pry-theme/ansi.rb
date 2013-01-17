module PryTheme

  ANSI = Struct.new(:options) do
    def foreground
      Layer.foreground(options)
    end

    def background
      Layer.background(options)
    end

    def readable_fg
      options[:foreground]
    end

    def readable_bg
      options[:background]
    end

    def bold
      Effects.bold(options)
    end

    def italic
      Effects.italic(options)
    end

    def underline
      Effects.underline(options)
    end
  end

end
