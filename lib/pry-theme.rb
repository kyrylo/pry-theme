require 'pry-theme/hex'
require 'pry-theme/rgb'
require 'pry-theme/term'
require 'pry-theme/formattable'
require 'pry-theme/declaration'
require 'pry-theme/definition'
require 'pry-theme/theme'
require 'pry-theme/color'

module PryTheme

  # The VERSION file must be in the root directory of the library.
  VERSION_FILE = File.expand_path('../../VERSION', __FILE__)

  VERSION = File.exist?(VERSION_FILE) ?
    File.read(VERSION_FILE).chomp : '(could not find VERSION file)'

  class << self
    # @since 0.2.0
    # @api public
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
  end

end
