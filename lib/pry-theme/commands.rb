module PryTheme
  Commands = Pry::CommandSet.new do

    create_command "pry-theme", "Manage your Pry themes." do
      include PryTheme::Helper

      banner <<-BANNER
        Usage: pry-theme [OPTIONS] [--help]

        Change your theme on the fly.

          pry-theme pry-modern

        Display 8-color palette.

          pry-theme --all-colors 8

        Display Pry Theme code for terminal color 34.

          pry-theme -c 34

        Test your current color theme.

          pry-theme -t

        Show a list with currently installed themes

          pry-theme --list

        Wiki: https://github.com/kyrylo/pry-theme/wiki/Pry-Theme-CLI
      BANNER

      def options(opt)
        opt.on :a, "all-colors", "Show all available 8/256 colors."
        opt.on :c, "color",      "Show information about a specific color (256)."
        opt.on :t, "test",       "Test your current theme", :argument => false
        opt.on :l, "list",       "Show a list with all available themes", :argument => false
      end

      def process
        if opts.a?
          show_palette_colors
        elsif opts.c?
          show_specific_color
        elsif opts.t?
          test_theme
        elsif opts.l?
          show_list
        elsif args[0] =~ /\A\w+-?\w+\z/
          switch_to_theme
        end
      rescue NoPaletteError => no_palette_error
        warn no_palette_error
      rescue NoColorError => no_color_error
        warn no_color_error
      end

      private

      def switch_to_theme
        PryTheme.set_theme(args[0].strip) and
        output.puts "Using #{ args[0] } theme"
      end

      def show_palette_colors
        lputs Palette.new(args[0]).to_a.join("\n")
      end

      def show_specific_color
        unless args[0] =~ /\A(\d{1,3})\z/ && (0...256).include?($1.to_i)
          raise NoColorError, "Invalid color number: #{ args[0] }"
        end

        pal = Palette.new(256)
        color = pal.colors.detect { |c| c.term == args[0].to_i }

        if color
          output.puts color.to_term(pal.notation)
        end
      end

      def test_theme
        example = <<-TEST
# Time for testing your colors!
module PryTheme
  module JustTesting

    THIS_IS_CONSTANT = :this_is_symbol

    class ThisIsClass

      def this_is_method
        this_is_float   = 10_000.00
        this_is_integer = 10_000

        "this_is_string"

        TRUE or FALSE or ARGV # <-- Predefined constants

        @this_is_instance_variable
        @@this_is_class_variable

        `echo 'Hello, hi, from "system" call!'`

        $ # <-- The dollar is an error!

        /[0-9]{1,3}this is regexp\\w+/xi
        $1 or $2 or $3333
      end

    end
  end
end
# Testing complete.
        TEST

        lputs colorize_code(example)
      end

      def show_list
        old_theme = PryTheme.current_theme.dup

        all_themes = installed_themes.map do |theme|
          theme.sub!(/\.prytheme\z/, "")
          PryTheme.set_theme(theme)

          chunk = <<-CHUNK
class PickMe
  def please
    @i, @@beg, you = 10_000, 400.00, "please!"
  end
end
          CHUNK

          header = make_bold("[#{theme}]")
          header.concat(" *") if theme == old_theme
          snippet = colorize_code(chunk)
          [header, "---", snippet].join("\n")
        end

        lputs all_themes.join("\n")
      ensure
        PryTheme.set_theme(old_theme)
      end
    end

  end
end
