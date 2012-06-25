module PryTheme
  class Theme

    attr_reader :scheme, :author, :description, :color_depth, :version, :name

    def initialize(theme_filename)
      theme = Psych.load_file(File.join(THEME_DIR, "#{theme_filename}.prytheme"))
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
end
