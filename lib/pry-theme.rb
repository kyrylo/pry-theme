require 'pry-theme/version'
require 'pry-theme/commands'
require 'pry-theme/palette'
require 'pry-theme/theme'
require 'pry-theme/when_started_hook'
require 'pry'
require 'psych'

module PryTheme

  ROOT_PATH = File.expand_path("../../", __FILE__)
  THEME_DIR = File.join(ENV["XDG_CONFIG_HOME"], "pry-theme")

  Setter = proc do |theme_name|
    ::CodeRay::Encoders::Terminal::TOKEN_COLORS.merge!(PryTheme.convert(theme_name))
  end

  def self.convert(theme_name)
    theme   = Theme.new(theme_name)
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

    notation = "38;5" if palette.color_depth == 256

    [notation, color_fg, formatting, color_bg].flatten.compact.join(";")
  end

end

# Apply a theme of a user from their theme file.
Pry.config.hooks.add_hook(:when_started, :apply_user_theme, PryTheme::WhenStartedHook.new)

# Import the PryTheme commands.
Pry.config.commands.import PryTheme::Commands
