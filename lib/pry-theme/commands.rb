# coding: utf-8

module PryTheme
  Command = Class.new

  class Command::PryTheme < Pry::ClassCommand
    include Pry::Helpers::BaseHelpers
    include Pry::Helpers::CommandHelpers

    match 'pry-theme'
    description 'Manage your Pry themes.'

    banner <<-'BANNER'
      Usage: pry-theme [OPTIONS] [--help]

      The command comes from `pry-theme` plugin. It enbales color theme support for your
      Pry. Pry Theme comes with a built-in editor. In order to use it you must install
      Sinatra gem (`gem install sinatra`).

      Wiki: https://github.com/kyrylo/pry-theme/wiki/Pry-Theme-CLI
      Cheatsheet: https://github.com/kyrylo/pry-theme/wiki/Pry-Theme-Cheatsheet

      pry-theme try pry-modern-256 # changes theme on the fly
      pry-theme current            # shows currently active theme name
      pry-theme current --colors   # tests colors from the current theme
      pry-theme list               # shows all installed themes
      pry-theme list --remote      # shows all themes from Pry Theme Collection
      pry-theme colors             # shows a list of all colors
      pry-theme colors --model 8   # shows a list of colors according to 8 color model
      pry-theme install autumn     # installs a theme from Pry Theme Collection
      pry-theme uninstall monokai  # uninstalls a theme
      pry-theme convert -m 16 -t 3 # converts a single color to a term color
      pry-theme edit solarized     # open "solarized" theme in the Pry Theme editor
    BANNER

    def def_list(cmd)
      cmd.command :list do |opt|
        opt.description 'Show a list of all installed themes'

        opt.on :r, :remote, 'Show a list of all themes from Pry Theme Collection'

        opt.run do |opts, args|
          opts.present?(:r) ? show_remote_list : show_local_list
        end
      end
    end

    def def_colors(cmd)
      cmd.command :colors do |opt|
        opt.description 'Show all available colors'

        opt.on :m, :model=, 'Display colors according to the given color model'

        opt.run do |opts, args|
          if opts.present?(:m)
            display_colors(opts[:m].to_i)
          else
            display_colors(PryTheme.tput_colors)
          end
        end
      end
    end

     def def_create(cmd)
      cmd.command :create do
      end
    end

    def def_try(cmd)
      cmd.command :try do |opt|
        opt.description 'Change theme on the fly (for the current session only)'

        opt.run do |opts, args|
          if PryTheme::ThemeList.activate_theme(args.first)
            output.puts %|Using "#{ args.first }" theme|
          elsif args.first
            output.puts %|Cannot find "#{args.first}" amongst themes in #{USER_THEMES_DIR}|
          end
        end
      end
    end

    def def_convert(cmd)
      cmd.command :convert do |opt|
        opt.description 'Convert the given color to proper terminal equivalent'

        opt.on :t, :term=,  'Show a terminal color'
        opt.on :h, :hex=,   'Convert from HEX'
        opt.on :r, :rgb=,   'Convert from RGB'
        opt.on :m, :model=, 'Convert accordingly to the given color model'

        opt.run do |opts, args|
          if color_model_option_only?(opts)
            output.puts 'Provide a color value to be converted'
          else
            convert_color(opts, args)
          end
        end
      end
    end

    def def_uninstall(cmd)
      cmd.command :uninstall do |opt|
        opt.description 'Uninstall a theme'

        opt.run do |opts, args|
          args.each { |theme|
            begin
              FileUtils.rm(File.join(USER_THEMES_DIR, "#{ theme }.prytheme.rb"))
              output.puts %|Successfully uninstalled "#{ theme }"!|
            rescue
              output.puts %|Cannot find theme "#{ theme }"|
            end
          }
        end
      end
    end

    def def_install(cmd)
      cmd.command :install do |opt|
        opt.description 'Install a theme from Pry Theme Collection'

        opt.run do |opts, args|
          install_theme(args)
        end
      end
    end

    def def_current(cmd)
      cmd.command :current do |opt|
        opt.description 'Shows information about currently active theme'

        opt.on :c, :colors, 'Display a painted code snippet'

        opt.run do |opts, args|
          current_theme_name = ThemeList.current_theme.name

          if opts.present?(:c)
            stagger_output(colorize_code(unindent <<-TEST))
              # "#{ current_theme_name }" theme.
              class PryTheme::ThisIsAClass
                def this_is_a_method
                  THIS_IS_A_CONSTANT  = :this_is_a_symbol
                  this_is_a_local_var = "\#{this} \#@is a string.\\n"
                  this_is_a_float     = 10_000.00
                  this_is_an_integer  = 10_000

                  # TRUE and FALSE are predefined constants.
                  $this_is_a_global_variable = TRUE or FALSE

                  @this_is_an_instance_variable = `echo '\#@hi \#{system} call\\n'`
                  @@this_is_a_class_variable    = @@@\\\\$ # An error.

                  /[0-9]{1,3}this \#{is} a regexp\\w+/xi
                end
              end
            TEST
          elsif args.empty?
            output.puts current_theme_name
          end
        end
      end
    end

    def def_edit(cmd)
      cmd.command :edit do |opt|
        opt.description 'Edits a theme'

        opt.run do |opts, args|
          if args.first
            theme = PryTheme::ThemeList.themes.find { |t| t.name == args.first }
            if theme
              PryTheme::Editor::App.edit(theme)
            else
              output.puts %|"#{ args.first }" theme is not found|
            end
          else
            PryTheme::Editor::App.edit(ThemeList.current_theme)
          end
        end
      end
    end

    def subcommands(cmd)
      [:def_list, :def_colors, :def_create, :def_try, :def_uninstall,
       :def_install, :def_current, :def_convert, :def_edit
      ].each { |m| __send__(m, cmd) }

      cmd.add_callback(:empty) do
        stagger_output opts.help
      end
    end

    def process
    end

    private

    def show_table(up)
      colors = []
      0.upto(up-1) { |i|
        color = PryTheme.const_get(:"Color#{ up }").new(
          :from => :term, :foreground => i)
        colors << build_color_string(color, i)
      }
      table = Pry::Helpers.tablify_or_one_line("Color model #{ up }", colors)
      stagger_output table
    end

    def build_color_string(color, fg = nil)
      "\e[7;%sm%s\e[0m:\e[%sm%s\e[0m" %
        [color.to_ansi, fg || color.foreground,
         color.to_ansi, color.foreground(true)]
    end

    def display_colors(color_model)
      case color_model
      when 256 then show_table(256)
      when 16  then show_table(16)
      when 8   then show_table(8)
      end
    end

    def show_local_list
      out = ''
      cur_theme = ThemeList.current_theme
      cur_theme.disable

      ThemeList.each { |theme|
        out += Pry::Helpers::Text.bold("#{theme.name} / #{theme.color_model}\n")
        out += theme.description
        out += "\n--\n"

        theme.activate
        out += colorize_code(unindent(<<-'CODE'
          1: class Theme
          2:   def method
          3:     @ivar, @@cvar, lvar = 10_000, 400.00, "string"
          4:   end
          5: end
        CODE
        ))
        theme.disable
        out += "\n"
      }
      stagger_output out.chomp
    ensure
      cur_theme.activate
    end

    def show_remote_list
      output.puts 'Fetching the list of themes from Pry Theme Collection...'
      output.puts "#{windows?? '->':'→'} https://github.com/kyrylo/pry-theme-collection/"
      body = json_body(PryTheme::PTC)

      themes = body.map { |theme|
        unless installed?(theme)
          [theme['name'], theme['html_url']]
        end
      }.compact

      out = "--\n"
      themes.each.with_index(1) { |theme, i|
        out += "#{ i }. "
        out += theme.first + "\n"

        uri = URI.parse(PryTheme::SHORTENER + theme.last)
        http = Net::HTTP.new(uri.host, uri.port)
        response = http.request(Net::HTTP::Get.new(uri.request_uri))

        out += response.body + "\n\n"
      }
      stagger_output out.chomp
    end

    def json_body(address)
      require 'net/https'
      require 'json'
      require 'base64'

      uri = URI.parse(address)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if windows?
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      JSON.parse(response.body)
    end

    def install_theme(args)
      args.each { |theme|
        output.puts %|Installing "#{ theme }" from Pry Theme Collection...|
        body = json_body(PTC + "%s/%s.prytheme" % [theme, theme])

        if body['message']
          output.puts %|Cannot find theme "#{ theme }"...|
          next
        end

        File.open(File.join(USER_THEMES_DIR, "#{theme}.prytheme.rb"), 'w') do |f|
          f.puts Base64.decode64(body['content'])
        end
        require File.join(USER_THEMES_DIR, "#{theme}.prytheme.rb")
        output.puts %|Successfully installed "#{ theme }"!|
      }
    end

    def convert_color(opts, args)
      color_model = (opts.present?(:m) ? opts[:m] : PryTheme.tput_colors)

      if opts.present?(:t)
        color = PryTheme.color_const(color_model).new(
          :from => :term, :foreground => opts[:t].to_i)
      elsif opts.present?(:h)
        color = PryTheme.color_const(color_model).new(
          :from => :hex, :foreground => opts[:h])
      elsif opts.present?(:r)
        color = PryTheme.color_const(color_model).new(
          :from => :rgb, :foreground => opts[:r])
      end
      output.puts build_color_string(color)
    rescue NameError
      output.puts %|Unknown color model "#{ opts[:m] }". Try 8, 16 or 256|
    end

    def color_model_option_only?(opts)
      opts[:m] && !(opts[:h] || opts[:r] || opts[:t])
    end

    def installed?(theme)
      theme['name'] == 'README.md' ||
        ThemeList.themes.map(&:name).include?(theme['name'])
    end
  end

  Pry::Commands.add_command(PryTheme::Command::PryTheme)
end
