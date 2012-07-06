require 'fileutils'

module PryTheme
  class WhenStartedHook
    include PryTheme::Helper

    def call(target, options, _pry_)
      FileUtils.mkdir_p(THEME_DIR) unless File.exists?(THEME_DIR)

      example_themes.each do |theme|
        # Copy a default theme to theme directory if it isn't there yet. Update
        # an installed theme if a theme from the gem has a more recent version
        # (version determines by theme's meta information).
        if File.exists?(local_theme(theme))
          new_version = theme_file_version(default_theme(theme))
          old_version = theme_file_version(local_theme(theme))

          if new_version > old_version
            FileUtils.cp(default_theme(theme), THEME_DIR)
          end
        else
          FileUtils.cp(default_theme(theme), THEME_DIR)
        end
      end

      if Pry.config.theme
        if Helper.installed?(Pry.config.theme)
          PryTheme.set_theme(Pry.config.theme)
        else
          _pry_.output.puts %{Can't find "#{Pry.config.theme}" theme. Using "#{DEFAULT_THEME_NAME}"}
          PryTheme.set_theme(DEFAULT_THEME_NAME)
        end
      else
        _pry_.output.puts %{Can't find `Pry.config.theme` definition in your `~/.pryrc`.\nUsing "pry-classic" theme now.}
      end
    end

  end
end
