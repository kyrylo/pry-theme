require 'fileutils'

module PryTheme
  class WhenStartedHook

    def call(target, options, _pry_)
      Dir.mkdir(THEME_DIR) unless Dir.exists?(THEME_DIR)

      (Dir.entries("examples") - %w{ . .. }).each do |f|
        unless File.exists?(File.join(THEME_DIR, f))
          FileUtils.cp(File.join("examples", f), THEME_DIR)
        end
      end

      theme_name = Pry.config.theme || "pry-classic"
      PryTheme::Setter.call(theme_name)
    end

  end
end
