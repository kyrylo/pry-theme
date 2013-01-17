module PryTheme
  module Formattable

    EFFECTS = {
      :bold      => 1,
      :italic    => 3,
      :underline => 4
    }

    def bold
      options[:bold] && EFFECTS[:bold]
    end

    def italic
      options[:italic] && EFFECTS[:italic]
    end

    def underline
      options[:underline] && EFFECTS[:underline]
    end

  end
end
