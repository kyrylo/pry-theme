module PryTheme
  module Helper

    module_function

    def example_themes
      (Dir.entries(EXAMPLES_ROOT) - %w{ . .. })
    end

    def installed_themes
      (Dir.entries(THEME_DIR) - %w{ . .. })
    end

    def installed?(theme)
      installed_themes.any? { |t| /\A#{theme}.prytheme\z/ =~ t }
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

    def pathify_theme(name)
      File.join(THEME_DIR, "#{ name }.prytheme")
    end

    def fetch_collection(path, &block)
      uri = URI.parse(COLLECTION + path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      yield(http, uri)
    end

  end
end
