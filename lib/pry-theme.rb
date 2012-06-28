require 'pry-theme/version'
require 'pry-theme/commands'
require 'pry-theme/palette'
require 'pry-theme/theme'
require 'pry-theme/when_started_hook'
require 'pry'
require 'psych'

module PryTheme

  # The root path for PryTheme source codes.
  ROOT = File.expand_path(File.dirname(__FILE__))

  # The root path for PryTheme examples.
  EXAMPLES_ROOT = File.join(ROOT, "..", "examples")

  # The root path for the directory with configuration files for OS you're using.
  CONFIG_DIR = case RbConfig::CONFIG["host_os"]
               when /darwin/
                 File.join(ENV["HOME"], "Library", "Application Support")
               when /linux/
                 ENV["XDG_CONFIG_HOME"]
               when /mingw|mswin/
                 ENV["APPDATA"]
               end

  # Pry themes' directory.
  THEME_DIR = File.join(CONFIG_DIR, "pry-theme")

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
                        (?<fg>
                          \w+(0[1-9])?
                        )
                        \s?
                      )?

                      # Matches "yellow (bu)" or "(bu)".
                      (
                        \(
                          (?<attrs>
                            d?b?u?i? # Order matters.
                          )
                        \)
                      )?


                      # Matches "yellow (bu) on red" or "on red".
                      (
                        \s?
                        on\s
                        (?<bg>
                          [a-z]+(0[1-9])?
                        )
                      )?

                      \z
                    /x
    m = color.match(color_pattern)

    color_fg   = if m[:fg]
                   palette.colors.find do |color|
                     color.human == m[:fg].to_sym
                   end.term
                 end

    formatting = if m[:attrs]
                   formatting = m[:attrs].each_char.map do |ch|
                     Formatting::ATTRIBUTES[ch]
                   end
                 end

    color_bg   = if m[:bg]
                   Formatting::BACKGROUNDS[m[:bg]]
                 end

    notation = palette.notation ? palette.notation[0..-2] : ""
    [notation, color_fg, formatting, color_bg].flatten.compact.join(";")
  end

end

# Apply a theme of a user from their theme file.
Pry.config.hooks.add_hook(:when_started, :apply_user_theme, PryTheme::WhenStartedHook.new)

# Import the PryTheme commands.
Pry.config.commands.import PryTheme::Commands
