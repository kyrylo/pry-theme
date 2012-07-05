require 'pry-theme/version'
require 'pry-theme/helper'
require 'pry-theme/commands'
require 'pry-theme/palette'
require 'pry-theme/theme'
require 'pry-theme/when_started_hook'
require 'pry-theme/uninstaller'

require 'yaml'

module PryTheme

  # The root path for PryTheme source codes.
  ROOT = File.expand_path(File.dirname(__FILE__))

  # The root path for PryTheme examples.
  EXAMPLES_ROOT = File.join(ROOT, "..", "examples")

  # The root path for the directory with configuration files for OS you're using.
  CONFIG_DIR = case RbConfig::CONFIG["host_os"]
               when /mingw|mswin/
                 File.join(ENV["APPDATA"], "pry-theme")
               else
                 # /darwin|linux/ and friends.
                 File.join(ENV["HOME"], ".pry")
               end

  # Pry themes' directory.
  THEME_DIR = File.join(CONFIG_DIR, "themes")

  # The name of the default theme of Pry Theme.
  DEFAULT_THEME_NAME = "pry-classic"

  # The URI for GitHub API link to Pry Theme Collection contents.
  COLLECTION = "https://api.github.com/repos/kyrylo/pry-theme-collection/contents"

  def self.set_theme(theme_name)
    return unless theme = PryTheme.convert(theme_name)
    ::CodeRay::Encoders::Terminal::TOKEN_COLORS.merge!(theme)
    @current_theme = theme_name
  end

  def self.current_theme
    @current_theme
  end

  def self.convert(theme_name)
    begin
      theme = Theme.new(theme_name)
    rescue NoThemeError => no_theme_error
      warn no_theme_error
      return
    end

    palette = Palette.new(theme.color_depth)
    scheme  = {}

    theme.scheme.each_pair do |k, v|
      if v.is_a?(Hash)
        nested_h = {}

        v.each_pair do |nested_k, nested_v|
          nested_h[nested_k.to_sym] = color_to_term(nested_v, palette)
        end

        scheme[k.to_sym] = nested_h
      else
        scheme[k.to_sym] = color_to_term(v, palette)
      end
    end

    scheme
  end

  def self.color_to_term(color, palette)
    color_pattern = /
                      \A

                      # Matches "yellow".
                      (
                        (
                          \w+(0[1-9])?
                        )
                        \s?
                      )?

                      # Matches "yellow (bu)" or "(bu)".
                      (
                        \(
                          (
                            d?b?u?i? # Order matters.
                          )
                        \)
                      )?


                      # Matches "yellow (bu) on red" or "on red".
                      (
                        \s?
                        on\s
                        (
                          \w+(0[1-9])?
                        )
                      )?

                      \z
                    /x

    if color
      m = color.match(color_pattern)

      color_fg   = find_color($2, palette) { |c| c.term }

      formatting = if $5
                     formatting = $5.each_char.map do |ch|
                       Formatting::ATTRIBUTES[ch]
                     end
                   end

      color_bg   = find_color($7, palette) do |c|
                     if palette.color_depth == 256
                       "48;5;#{c.term}"
                      else
                        Formatting::BACKGROUNDS[c.human.to_s]
                     end
                   end

      # Uh oh :(
      notation = if !color_fg
                   "38;0"
                 elsif palette.notation
                   palette.notation[0..-2]
                 else
                   nil
                 end

      [notation, color_fg, formatting, color_bg].flatten.compact.join(";")
    else
      # In cases when a user decided not to provide an argument value in theme,
      # use default color. Not handling this situation results in CodeRay's
      # error ("can't convert nil into String" stuff).
      "38;0;0"
    end
  rescue NoColorError => e
    Pry.output.puts "#{e}: wrong color value: `#{color}`. Typo?"
  end

  def self.install_gem_hooks
    Gem.post_uninstall do |u|
      Uninstaller.run(u) if u.spec.name == "pry-theme"
    end
  end

  def self.find_color(color, palette, &block)
    if color
      c = palette.colors.find do |palette_color|
        palette_color.human == color.to_sym
      end

      if c
        block.call(c)
      else
        raise NoColorError
      end
    end
  end

end

# Apply a theme of a user from their theme file.
Pry.config.hooks.add_hook(:when_started, :apply_user_theme, PryTheme::WhenStartedHook.new)

# Import the PryTheme commands.
Pry.config.commands.import PryTheme::Commands
