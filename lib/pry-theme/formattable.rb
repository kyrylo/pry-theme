module PryTheme
  module Formattable

    FORMATTING = {
      :bold      => 1,
      :italic    => 3,
      :underline => 4
    }

    def bold
      options[:bold] && FORMATTING[:bold]
    end
    def bold?; !!bold; end

    def italic
      options[:italic] && FORMATTING[:italic]
    end
    def italic?; !!italic; end

    def underline
      options[:underline] && FORMATTING[:underline]
    end
    def underline?; !!underline; end

  end
end
