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

    def theme_file_version(path)
      version = File.foreach(path) { |line| break line if $. == 4 }
      version.scan(/\d+/)[0].to_i
    end

    def default_theme(name)
      File.join(EXAMPLES_ROOT, name)
    end

    def local_theme(name)
      File.join(THEME_DIR, name)
    end

  end
end
