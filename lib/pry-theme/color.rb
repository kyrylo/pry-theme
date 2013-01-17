module PryTheme
  class Color
    include Layered
    include Formattable

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def readable_fg
      options[:foreground]
    end

    def readable_bg
      options[:background]
    end
  end
end
