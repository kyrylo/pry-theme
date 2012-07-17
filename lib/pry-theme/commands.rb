require 'net/https'
require 'base64'
require 'json'

module PryTheme
  Commands = Pry::CommandSet.new do

    create_command "pry-theme", "Manage your Pry themes." do
      include PryTheme::Helper

      banner <<-BANNER
        Usage: pry-theme [OPTIONS] [--help]

        Change your theme on the fly (for one session).

          pry-theme pry-modern

        Show all themes from Pry Theme Collection.

          pry-theme -r

        Install a theme from Pry Theme Collection.

          pry-theme -i pry-classic

        Test your current color theme.

          pry-theme -t

        Wiki: https://github.com/kyrylo/pry-theme/wiki/Pry-Theme-CLI
      BANNER

      def options(opt)
        opt.on :a, "all-colors",  "Show all available 8/256 colors."
        opt.on :c, "color",       "Show information about a specific color (256)."
        opt.on :t, "test",        "Test your current theme", :argument => false
        opt.on :e, "edit",        "Edit/reload current .prytheme", :argument => false
        opt.on :l, "list",        "Show a list of installed themes", :argument => false
        opt.on :r, "remote-list", "Show a list of themes from Pry Theme Collection", :argument => false
        opt.on :i, "install",     "Install a theme from Pry Theme Collection"
      end

      def process
        if opts.a?
          show_palette_colors
        elsif opts.c?
          show_specific_color
        elsif opts.t?
          test_theme
        elsif opts.e?
          edit_theme
        elsif opts.l?
          show_list
        elsif opts.r?
          show_remote_list
        elsif opts.i?
          install_theme
        elsif args[0] =~ /\A\w+-?\w+\z/
          switch_to_theme
        elsif args.empty?
          output.puts "Current theme: #{PryTheme.current_theme}"
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
        lputs in_columns(Palette.new(args[0]).to_a), output
      end

      def in_columns(list, cols=3)
        color_table = []

        list.each_slice(cols) do |slice|
          slice.each do |c|
            color = c.scan(/(\e\[[[0-9];]+m)(\w+)(\e\[0m)(:)(\e\[[[0-9];]+m)(\w+)(\e\[0m)/).flatten
            color[1] = color[1].ljust(3)
            color[-2] = color[-2].ljust(22)
            color_table << color
          end
          color_table << "\n"
        end
        color_table.join
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
# "#{PryTheme.current_theme}" theme.
        TEST

        lputs colorize_code(example), output
      end

      def edit_theme
        cur = PryTheme.current_theme
        file_name = PryTheme::Theme.pathify_theme cur
        Pry.run_command 'edit ' + file_name
        begin
          PryTheme.set_theme(cur).nil? and
            raise Pry::CommandError, 'PryTheme.set_theme failed for ' + cur
          test_theme
        rescue Pry::RescuableException => e
          output.puts e.inspect
          output.puts Pry::Helpers::Text.red('Oops. Probably try again.')
        end
      end

      def show_list
        old_theme = PryTheme.current_theme.dup

        all_themes = installed_themes.map do |theme|
          theme = File.basename(theme, ".prytheme")
          meta = Theme.new(theme)
          PryTheme.set_theme(theme)

          chunk = <<-CHUNK
class PickMe
  def please
    @i, @@beg, you = 10_000, 400.00, "please!"
  end
end
          CHUNK

          mark_current = "* " if theme == old_theme
          header = make_bold("#{mark_current}[#{theme}]")
          snippet = colorize_code(chunk)
          [header, meta.description, "---", snippet].compact.join("\n")
        end

        lputs all_themes.join("\n"), output
      ensure
        PryTheme.set_theme(old_theme)
      end

      def show_remote_list
        body = {}
        fetch_collection("/") do |http, uri|
          output.puts "Fetching list of themes..."
          response = http.request(Net::HTTP::Get.new(uri.request_uri))
          body = JSON.parse(response.body)
        end

        i = 0
        remote_themes = body.map do |theme|
          if (name = theme["name"]) =~ /\A[[a-z][0-9]-]+\z/
            "#{i+=1}. #{installed?(name) ? make_bold(name) : name}"
          end
        end.compact

        lputs remote_themes.join("\n"), output
      end

      def install_theme
        return unless args[0]

        body = {}
        fetch_collection("/#{args[0]}/#{args[0]}.prytheme") do |http, uri|
          output.puts "Fetching theme from the collection..."
          response = http.request(Net::HTTP::Get.new(uri.request_uri))
          body = JSON.parse(response.body)
        end

        if body["message"]
          output.puts "Cannot find theme: #{args[0]}"
          return
        end

        theme = Base64.decode64(body["content"])

        File.open(local_theme("#{args[0]}.prytheme"), "w") do |f|
          f.puts theme
        end

        output.puts "Successfully installed #{args[0]}!"
      rescue
        output.puts "An error occurred!"
      end
    end

  end
end
