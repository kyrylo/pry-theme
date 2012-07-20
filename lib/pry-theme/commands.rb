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
        opt.on :e, "edit",        "Edit or create a theme"
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
        c = args[0]

        unless c
          output.puts "This option requires an argument. Specify a color. Examples:"
          output.puts "Pry Theme: black; RGB: 0,0,0; HEX: #000000, ANSI: 0."
          return
        end

        color = if ansi?(c)
                  find_color(c)
                elsif hex?(c)
                  find_color(ColorConverter.hex_to_ansi(c))
                elsif rgb?(c)
                  find_color(ColorConverter.rgb_to_ansi(c))
                else
                  h = ColorConverter::COLORS.select do |color|
                    (color.human).to_s[c]
                  end

                  # Return human-readable colors if the
                  # select selected any. If not, return nil.
                  h if h.any?
                end

        case color
        when Array
          lputs color.map { |c| c.to_term("38;5;") }.join("\n"), output
        when nil
          output.puts "Invalid color: #{ c }"
        else
          output.puts color.to_term("38;5;")
        end
      end

      def find_color(color)
        ColorConverter::COLORS.find { |c| c.term == color.to_i }
      end

      def test_theme
        example = <<-TEST
# Time for testing your colors!
module PryTheme
  module JustTesting

    THIS_IS_A_CONSTANT = :this_is_a_symbol

    class ThisIsClass

      def this_is_a_method
        this_is_a_float   = 10_000.00
        this_is_an_integer = 10_000

        "this_is_a_string"

        TRUE or FALSE or ARGV # <-- Predefined constants

        @this_is_an_instance_variable
        @@this_is_a_class_variable

        `echo 'Hello, hi, from a "system" call!'`

        $ # <-- The dollar is an error!

        /[0-9]{1,3}this is a regexp\\w+/xi
        $this_is_a_global_variable
      end

    end
  end
end
# "#{ PryTheme.current_theme }" theme.
        TEST

        lputs colorize_code(example), output
      end

      def edit_theme
        theme = args[0] || PryTheme.current_theme
        new_theme_flag = theme[0] == "+"

        if not new_theme_flag and not installed?(theme)
          output.puts "Can't find #{ theme } theme in #{ THEME_DIR } directory."
          output.puts "To create a new theme, prepend a `+` sign to the name."
          output.puts "For example: `pry-theme -e +#{ theme }`."
          return
        elsif new_theme_flag and installed?(theme_name = theme.tr("+", ""))
          output.puts "Can't create a theme with the given name."
          output.puts "The #{ theme_name } theme is already installed in your system."
          output.puts "Try to edit it with `pry-theme -e #{ theme_name }` command."
          return
        end

        if new_theme_flag
          theme_path = pathify_theme(theme_name)
          template = <<-TEMPLATE
---
meta:
  theme-name  : #{ theme_name }
  version     : 1
  color-depth : # 8 or 256.
  description : # Should be less than 80 characters.
  author      : # John Doe <johndoe@example.com>

theme:
  class               : # blue on yellow
  class_variable      : # red
  comment             : # on green
  constant            : # (bu)
  error               : # black (b) on white
  float               : # (i)
  global_variable     :
  instance_variable   :
  integer             :
  keyword             :
  method              :
  predefined_constant :
  regexp:
    self              :
    content           :
    delimiter         :
    modifier          :
    function          :
  shell:
    self              :
    content           :
    delimiter         :
  string:
    self              :
    content           :
    modifier          :
    escape            :
    delimiter         :
  symbol              :
          TEMPLATE

          begin
            new_theme = File.new(theme_path, "w")
            new_theme.puts template
            _pry_.run_command "edit #{ theme_path }"

            output.puts %(Created new theme in `#{ THEME_DIR }` with name "#{ theme_name }")
            output.puts "and opened in #{ Pry.config.editor } for editing."
          ensure
            new_theme.close
          end
        else
          PryTheme.set_theme(theme)
          output.puts "Using #{ theme } as your current theme."

          _pry_.run_command "edit #{ pathify_theme(theme) }"
          output.puts "Opened #{ theme } theme in #{ Pry.config.editor } for editing."
          output.puts "Don't forget to increment a version number of theme!"
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
