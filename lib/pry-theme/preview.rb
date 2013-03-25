module PryTheme
  class Preview
    def initialize(theme)
      @theme = theme
    end

    def short
      cur_theme = ThemeList.current_theme
      @theme.activate
      [header, description, '--', short_snippet].join("\n")
    ensure
      @theme.disable
      cur_theme.activate
    end

    def description
      @theme.description
    end

    def header
      Pry::Helpers::Text.bold("#{ @theme.name } / #{ @theme.color_model }")
    end

    private

    def short_snippet
      code = Pry::Helpers::CommandHelpers.unindent(<<-'CODE')
        1: class Theme
        2:   def method
        3:     @ivar, @@cvar, lvar = 10_000, 400.00, "string"
        4:   end
        5: end
      CODE
      Pry::Helpers::BaseHelpers.colorize_code(code)
    end
  end
end
