module PryTheme
  module Effects
    extend self

    LIST = {
      :bold      => 1,
      :italic    => 3,
      :underline => 4
    }

    def bold(options)
      options[:bold] && LIST[:bold]
    end

    def italic(options)
      options[:italic] && LIST[:italic]
    end

    def underline(options)
      options[:underline] && LIST[:underline]
    end
  end
end
