require 'fileutils'

module PryTheme
  module Uninstaller

    def self.run(u)
      puts "Do you wish to delete #{THEME_DIR} directory with all Pry themes?"
      print "(y/n): "

      case $stdin.gets.chomp
      when "y"
        FileUtils.rm_rf(THEME_DIR)
        puts "Successfully deleted #{THEME_DIR} and all Pry themes."
      else
        puts "Nothing deleted. You can manually delete the directory."
      end
    end

  end
end
