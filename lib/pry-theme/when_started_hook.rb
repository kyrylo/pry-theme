module PryTheme
  class WhenStartedHook
    def call(target, options, _pry_)
      recreate_user_themes_from_default_ones
      load_themes

      if Pry.config.theme
        ThemeList.activate_theme(Pry.config.theme)
      else
        ThemeList.activate_theme_intelligently
      end
    end

    private

    # Copy a default theme to theme directory, but only if it isn't there yet.
    def recreate_user_themes_from_default_ones
      FileUtils.mkdir_p(USER_THEMES_DIR) unless File.exists?(USER_THEMES_DIR)
      default_themes = Dir.entries(DEF_THEMES_DIR) - %w{. ..}

      default_themes.each do |theme|
        user_theme_path = File.join(USER_THEMES_DIR, theme)
        unless File.exists?(user_theme_path)
          def_theme_path = File.join(DEF_THEMES_DIR, theme)
          FileUtils.cp(def_theme_path, USER_THEMES_DIR)
        end
      end
    end

    def load_themes
      user_themes = Dir.entries(USER_THEMES_DIR) - %w{. ..}
      user_themes.each do |theme|
        require File.join(USER_THEMES_DIR, theme)
      end
    end

  end
end
