module PryTheme
  class Theme

    attr_reader :scheme, :author, :description, :color_depth, :version, :name

    def initialize(theme_filename)
      theme_file = File.join(THEME_DIR, "#{theme_filename}.prytheme")

      if File.exists?(theme_file)
        theme = Psych.load_file(theme_file)
      else
        raise NoThemeError, "#{theme_filename}.prytheme doesn't exist"
      end

      meta = theme["meta"]

      @name        = meta["theme-name"]
      @version     = meta["version"]
      @color_depth = meta["color-depth"].to_i
      @description = meta["description"]
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
end
