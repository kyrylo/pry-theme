module PryTheme
  class Theme

    attr_reader :scheme, :author, :description, :color_depth, :version, :name

    def initialize(theme_filename)
      theme_file = Helper.pathify_theme(theme_filename)

      if File.exists?(theme_file)
        theme = YAML.load_file(theme_file)
      else
        raise NoThemeError, "#{theme_filename}.prytheme doesn't exist"
      end

      meta = theme["meta"]

      @name        = meta["theme-name"]
      @version     = meta["version"]
      @color_depth = meta["color-depth"].to_i

      # Forbid too long descriptions.
      if @description = meta["description"]
        if (size = @description.size) > 80
          raise ThemeDescriptionError, "Description of #{name} theme is too long (#{size}). Max size is 80 characters."
        end
      end

      @author      = meta["author"]
      @scheme      = theme["theme"]
    end

    def method_missing(method_name, *args, &block)
      if @scheme.has_key?(method_name.to_s)
        @scheme[method_name.to_s]
      else
        super
      end
    end

  end

  class NoThemeError < StandardError; end
  class ThemeDescriptionError < StandardError; end
end
