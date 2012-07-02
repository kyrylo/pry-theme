require 'fileutils'

module PryTheme
  class WhenStartedHook
    include PryTheme::Helper

    def call(target, options, _pry_)
      FileUtils.mkdir_p(THEME_DIR) unless File.exists?(THEME_DIR)

      example_themes.each do |theme|
        unless File.exists?(File.join(THEME_DIR, theme))
          FileUtils.cp(File.join(EXAMPLES_ROOT, theme), THEME_DIR)
        end
      end

      PryTheme.set_theme(Pry.config.theme)
    end

  end
end
