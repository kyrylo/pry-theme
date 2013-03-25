require 'fileutils'

require 'pry-theme/theme_list'
require 'pry-theme/when_started_hook'
require 'pry-theme/hex'
require 'pry-theme/rgb'
require 'pry-theme/term'
require 'pry-theme/formattable'
require 'pry-theme/declaration'
require 'pry-theme/definition'
require 'pry-theme/theme'
require 'pry-theme/color'
require 'pry-theme/basic_editor'
require 'pry-theme/commands'

module PryTheme

  # The VERSION file must be in the root directory of the library.
  VERSION_FILE = File.expand_path('../../VERSION', __FILE__)

  VERSION = File.exist?(VERSION_FILE) ?
    File.read(VERSION_FILE).chomp : '(could not find VERSION file)'

  # The root path of Pry Theme source code.
  ROOT = File.expand_path(File.dirname(__FILE__))

  # The path of the directory with Pry configuration files.
  CONFIG_DIR = File.join(ENV['HOME'], '.pry')

  # The path of the default Pry Theme themes.
  DEF_THEMES_DIR = File.join(ROOT, '..', 'themes')

  # The path where the user should keep their themes.
  USER_THEMES_DIR = File.join(CONFIG_DIR, 'themes')

  # Every Pry Theme file must end with this extension.
  PT_EXT = '.prytheme.rb'

  # Pry Theme Collection.
  PTC = 'https://api.github.com/repos/kyrylo/pry-theme-collection/contents/'

  # The default URL shortener (used for listing themes from PTC).
  SHORTENER = 'http://is.gd/create.php?format=simple&url='

  # @since 0.2.0
  # @api public
  class << self
    # @see https://github.com/kyrylo/pry-theme/wiki/Creating-a-New-Theme
    #
    # Creates a new Pry Theme theme.
    #
    # @example
    #   my_theme = PryTheme.create name: 'my-theme', color_model: 8 do
    #     author name: 'John Doe', email: 'johndoe@example.com'
    #     description 'My first theme'
    #
    #     define_theme do
    #       class_variable 'red'
    #       integer 'black'
    #       method 'white', 'red'
    #       symbol bg: 'yellow'
    #
    #       string do
    #         content 'blue', 'black'
    #       end
    #     end
    #   end
    #
    #   my_theme.definition.class_variable.foreground(true) #=> "red"
    #   my_theme.definition.string.content.background(true) #=> "black"
    #
    # @param [Hash] config
    # @option config [String] :name ('prytheme-\d+') The name of the theme. It
    #   must be no longer than 18 characters
    # @option config [Integer] :color_model (256) The number of colours
    #   available in the theme that is being created. Besides 256, valid
    #   arguments are `8` and `16`
    def create(config = {}, &block)
      Theme.new(config, &block)
    end

    # @return [Integer] the number of supported terminal colours. Always equal
    #   to 16 on Windows.
    def tput_colors
      `tput colors`.to_i
    rescue Errno::ENOENT
      16
    end

    # @param [Integer] color
    # @return [Class] the class, which corresponds to the given +color+
    def color_const(color)
      const_get(:"Color#{ color }")
    end
  end

  Pry.config.hooks.add_hook(:when_started, :pry_theme, WhenStartedHook.new)
end
