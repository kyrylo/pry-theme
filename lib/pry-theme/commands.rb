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
            color = c.scan(/(\e\[[\d;]+m)(\w+)(\e\[0m)(:)(\e\[[\d;]+m)(\w+)(\e\[0m)/).flatten
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
          lputs color.map { |c| c.to_term(TermNotation::COLOR256) }.join("\n"), output
        when nil
          output.puts "Invalid color: #{ c }"
        else
          output.puts color.to_term(TermNotation::COLOR256)
        end
      end

      def find_color(color)
        ColorConverter::COLORS.find { |c| c.term == color.to_i }
      end

      def test_theme
        example = <<-TEST
# "#{ PryTheme.current_theme }" theme.
class PryTheme::ThisIsAClass
  def this_is_a_method
    THIS_IS_A_CONSTANT  = :this_is_a_symbol
    this_is_a_local_var = "\#{this} is a string.\\n"
    this_is_a_float     = 10_000.00
    this_is_an_integer  = 10_000

    # TRUE and FALSE are predefined constants.
    $this_is_a_global_variable = TRUE or FALSE

    @this_is_an_instance_variable = `echo '\#{system} call\\n'`
    @@this_is_a_class_variable    = @$ # An error.

    /[0-9]{1,3}this \#{is} a regexp\\w+/xi
  end
end
        TEST

        lputs colorize_code(example), output
      end

      def edit_theme
        theme = args.first || PryTheme.current_theme
        theme.tr!("+", "") if new_theme_flag = (theme[0] == "+")

        if not new_theme_flag and not installed?(theme)
          output.puts %(Can't find "#{ theme }" theme in `#{ THEME_DIR }`.)
          output.puts "To create a new theme, prepend a `+` sign to its name."
          output.puts "Example: `pry-theme -e +#{ theme }`."
          return
        elsif new_theme_flag and installed?(theme)
          output.puts "Can't create a theme with the given name."
          output.puts %(The "#{ theme }" theme is already exist in your system.)
          output.puts "You can edit it with `pry-theme -e #{ theme }` command."
          return
        end

        theme_path = pathify_theme(theme)

        if new_theme_flag
          template = <<-TEMPLATE
---
meta:
  theme-name  : #{ theme }
  version     : 1
  color-depth : 256 # Supports 8 or 256 colors.
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
  inline_delimiter    :
  instance_variable   :
  integer             :
  keyword             :
  method              :
  predefined_constant :
  regexp:
    self              :
    char              :
    content           :
    delimiter         :
    modifier          :
    escape            :
  shell:
    self              :
    char              :
    content           :
    delimiter         :
    escape            :
  string:
    self              :
    char              :
    content           :
    delimiter         :
    escape            :
  symbol              :
          TEMPLATE

          # Create a template in themes directory.
          File.open(theme_path, "w") { |f| f.puts template }

          output.puts %(Created "#{ theme }" theme in `#{ THEME_DIR }`.)
          output.puts "Opened it in #{ Pry.config.editor } for editing."
        else
          output.puts "Opened #{ theme } theme in #{ Pry.config.editor } for editing."
          output.puts "Don't forget to increment a version number of theme!"
        end

        begin
          old_theme = PryTheme.current_theme

          display_preview!(theme, %<Current "#{ theme }">)
          invoke_editor(theme_path, line=1, reloading=true)
          display_preview!(theme, %<Edited "#{ theme }">)
        ensure
          PryTheme.set_theme(old_theme)
        end
      end

      # Please, pay attention to the fact that this method changes current
      # theme to the given theme.
      def display_preview!(theme, header_text)
        PryTheme.set_theme(theme)
        display_header(header_text, output)
        test_theme
      end

      def show_list
        old_theme = PryTheme.current_theme.dup

        all_themes = installed_themes.map do |theme|
          theme = File.basename(theme, ".prytheme")
          meta = Theme.new(theme)
          PryTheme.set_theme(theme)

          chunk = <<-CHUNK
class Theme
  def method
    @ivar, @@cvar, lvar = 10_000, 400.00, "string"
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
        require 'net/https'
        require 'json'

        body = {}
        fetch_collection("/") do |http, uri|
          output.puts "Fetching list of themes..."
          response = http.request(Net::HTTP::Get.new(uri.request_uri))
          body = JSON.parse(response.body)
        end

        i = 0
        remote_themes = body.map do |theme|
          if (name = theme["name"]) =~ /\A(?:[a-z]|[0-9]|-)+\z/
            "#{i+=1}. #{installed?(name) ? make_bold(name) : name}"
          end
        end.compact

        lputs remote_themes.join("\n"), output
      end

      def install_theme
        return unless args[0]

        require 'net/https'
        require 'json'
        require 'base64'

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
