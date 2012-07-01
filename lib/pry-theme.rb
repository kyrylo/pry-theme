require 'pry-theme/version'
require 'pry-theme/commands'
require 'pry-theme/palette'
require 'pry-theme/theme'
require 'pry-theme/when_started_hook'
require 'pry-theme/uninstaller'

require 'pry'
require 'yaml'

module PryTheme

  # The root path for PryTheme source codes.
  ROOT = File.expand_path(File.dirname(__FILE__))

  # The root path for PryTheme examples.
  EXAMPLES_ROOT = File.join(ROOT, "..", "examples")

  # The root path for the directory with configuration files for OS you're using.
  CONFIG_DIR = case RbConfig::CONFIG["host_os"]
               when /darwin|linux/
                 File.join(ENV["HOME"], ".pry")
               when /mingw|mswin/
                 File.join(ENV["APPDATA"], "pry-theme")
               end

  # Pry themes' directory.
  THEME_DIR = File.join(CONFIG_DIR, "themes")

  def self.set_theme(theme_name)
    if theme = PryTheme.convert(theme_name)
      ::CodeRay::Encoders::Terminal::TOKEN_COLORS.merge!(theme)
    end
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
                          [a-z]+(0[1-9])?
                        )
                      )?

                      \z
                    /x

    if color
      m = color.match(color_pattern)

      color_fg   = if $2
                     c = palette.colors.find do |color|
                       color.human == $2.to_sym
                     end

                     if c
                       c.term
                     else
                       raise NoColorError
                     end
                   end

      formatting = if $5
                     formatting = $5.each_char.map do |ch|
                       Formatting::ATTRIBUTES[ch]
                     end
                   end

      color_bg   = if $7
                     Formatting::BACKGROUNDS[$7]
                   end

      # Uh oh :(
      notation = if !color_fg
                   "38;0;"
                 elsif palette.notation
                   palette.notation[0..-2]
                 else
                   ""
                 end

      [notation, color_fg, formatting, color_bg].flatten.compact.join(";")
    else
      # In cases when a user decided not to provide an argument value in theme,
      # use default color. Not handling this situation results in CodeRay's
      # error ("can't convert nil into String" stuff).
      "38;0;0"
    end
  rescue NoColorError => e
    Pry.output.puts "#{e}: wrong color value: `#{$2}`. Typo?"
  end

  def self.install_gem_hooks
    Gem.post_uninstall do |u|
      Uninstaller.run(u)
    end
  end

end

# Apply a theme of a user from their theme file.
Pry.config.hooks.add_hook(:when_started, :apply_user_theme, PryTheme::WhenStartedHook.new)

# Import the PryTheme commands.
Pry.config.commands.import PryTheme::Commands
