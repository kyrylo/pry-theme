module PryTheme
  module Helper

    def example_themes
      (Dir.entries(EXAMPLES_ROOT) - %w{ . .. })
    end

    def installed_themes
      (Dir.entries(THEME_DIR) - %w{ . .. })
    end

    def lputs(text, out=nil)
      Pry::Helpers::BaseHelpers.stagger_output(text, out)
    end

    def make_bold(text)
      Pry::Helpers::Text.bold(text)
    end

  end
end
