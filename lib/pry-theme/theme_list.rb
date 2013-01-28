module PryTheme
  module ThemeList

    extend self

    def themes
      @themes ||= []
    end

    def add_theme(theme)
      themes << theme
    end

    def each(&block)
      themes.each(&block)
    end

    def current_theme
      themes.find { |theme| theme.active? }
    end

    def activate_theme(name)
      theme = themes.find { |theme| theme.name == name }

      if theme
        current_theme.disable if current_theme
        theme.activate
        true
      end
    end

    def activate_theme_intelligently
      if Pry::Helpers::BaseHelpers.windows?
        activate_theme('pry-classic-16')
      else
        case PryTheme.tput_colors
        when 256 then activate_theme('pry-classic-256')
        when 16  then activate_theme('pry-classic-16')
        else          activate_theme('pry-classic-8')
        end
      end
    end

  end
end
