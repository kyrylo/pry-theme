module PryTheme
  Commands = Pry::CommandSet.new do

    create_command "pry-theme", "Manage your Pry themes." do

      banner <<-BANNER
        Usage: pry-theme [OPTIONS]

        Change your theme on the fly.
        e.g.: pry-theme pry-modern
        e.g.: pry-theme pry-classic
        e.g.: pry-theme --all-colors
      BANNER

      def options(opt)
        opt.on :a, "all-colors", "Show all available 8/256 colors."
        opt.on :c, "color",      "Show information about a specific color (256)."
      end

      def process
        return if args.empty?

        if opts.a?
          output.puts Palette.new(args[0]).to_s
        elsif opts.c?
          unless args[0] =~ /\A(\d{1,3})\z/ && (0...256).include?($1.to_i)
            raise NoColorError, "Invalid color number: #{ args[0] }"
          end

          pal = Palette.new(256)
          color = pal.colors.detect { |c| c.term == args[0].to_i }

          if color
            output.puts color.to_term(pal.notation)
          end
        else
          PryTheme.set_theme(args[0].strip) and output.puts "Using #{ args[0] } theme"
        end
      rescue NoPaletteError => no_palette_error
        warn no_palette_error
      rescue NoColorError => no_color_error
        warn no_color_error
      end
    end

  end
end
