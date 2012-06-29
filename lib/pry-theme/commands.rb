module PryTheme
  Commands = Pry::CommandSet.new do

    create_command "pry-theme", "Manage your Pry themes." do

      banner <<-BANNER
        Usage: pry-theme [OPTIONS]

        Change your theme on the fly.
        e.g.: pry-theme pry-modern
        e.g.: pry-theme pry-classic
        e.g.: pry-theme --all-colors 8
      BANNER

      def options(opt)
        opt.on :a, "all-colors", "Show all available 8/256 colors."
        opt.on :c, "color",      "Show information about a specific color (256)."
        opt.on :t, "test",       "Test your current theme", :argument => false
      end

      def process
        if opts.a?
          show_palette_colors
        elsif opts.c?
          show_specific_color
        elsif opts.t?
          test_theme
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
        output.puts Palette.new(args[0]).to_s
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
        example = <<-"TEST".gsub(/^\s{10}/, '')
          # Time for testing your colors!
          module PryTheme
            module JustTesting

              THIS_IS_CONSTANT = :this_is_symbol

              class ThisIsClass

                def this_is_method
                  this_is_float   = 10_000.00
                  this_is_integer = 10_000

                  "this_is_string"
                  'this is another string'

                  @this_is_instance_variable
                  @@this_is_class_variable

                  /[0-9]{1,3}this is regexp\w+/xi
                  $1 or $2 or $3333

                  nil
                  self
                end

              end
            end
          end
          # Testing complete.
        TEST

        output.puts colorize_code(example)
      end
    end

  end
end
