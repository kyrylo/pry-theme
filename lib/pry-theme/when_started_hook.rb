module PryTheme
  class WhenStartedHook
    def call(target, options, _pry_)
      recreate_user_themes_from_default_ones
      load_themes

      if File.exist?(theme_file)
        ThemeList.activate_theme(Pry.config.theme)
      else
        display_warning(_pry_) if Pry.config.theme
        ThemeList.activate_theme_intelligently
      end
    end

    private

    # Copy a default theme to theme directory, but only if it isn't there yet.
    def recreate_user_themes_from_default_ones
      FileUtils.mkdir_p(USER_THEMES_DIR) unless File.exist?(USER_THEMES_DIR)
      default_themes = Dir.entries(DEF_THEMES_DIR) - %w{. ..}

      default_themes.each do |theme|
        user_theme_path = File.join(USER_THEMES_DIR, theme)
        unless File.exist?(user_theme_path)
          def_theme_path = File.join(DEF_THEMES_DIR, theme)
          FileUtils.cp(def_theme_path, USER_THEMES_DIR)
        end
      end
    end

    def load_themes
      user_themes = Dir[File.join(USER_THEMES_DIR, '*' + PT_EXT)]
      user_themes.each do |theme|
        require theme
      end
    end

    def theme_file
      File.join(USER_THEMES_DIR, Pry.config.theme.to_s + PT_EXT)
    end

    def display_warning(pry)
      pry.output.puts 'Pry Theme Warning: Pry.config.theme is set to ' +
        "\"#{ Pry.config.theme }\". There's no such a theme in your system. " +
        "All installed themes live inside #{ USER_THEMES_DIR }. Falling back " +
        'to the default theme for now.'
    end
  end
end
