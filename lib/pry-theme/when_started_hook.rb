require 'fileutils'

module PryTheme
  class WhenStartedHook

    def call(target, options, _pry_)
      FileUtils.mkdir_p(THEME_DIR) unless File.exists?(THEME_DIR)

      (Dir.entries(EXAMPLES_ROOT) - %w{ . .. }).each do |f|
        unless File.exists?(File.join(THEME_DIR, f))
          FileUtils.cp(File.join(EXAMPLES_ROOT, f), THEME_DIR)
        end
      end

      theme_name = Pry.config.theme || "pry-classic"
      PryTheme.set_theme(theme_name)
    end

  end
end
