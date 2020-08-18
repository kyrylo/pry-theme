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
      Pry. Set up your favorite theme in `~/.pryrc` config file. For example, if you
      enjoy Zenburn theme, add the following line: `Pry.config.theme = 'zenburn'`.

      You can create your own themes with help of `edit` subcommand. More information
      can be found in the appropriate arcticle: http://is.gd/YPuTjM
      Tokens cheatsheet might come in handy, too: http://is.gd/D7GoVe

      pry-theme try pry-modern-256 # changes theme (lasts for current session only)
      pry-theme current            # shows currently active theme name
      pry-theme current --colors   # tests colors from the current theme
      pry-theme list               # shows all installed themes as colorful snippets
      pry-theme list --remote      # shows all themes from Pry Theme Collection
      pry-theme colors             # shows the list of all color names
      pry-theme colors --model 8   # shows the list of colors according to 8 color model
      pry-theme install autumn     # installs a theme from Pry Theme Collection
      pry-theme uninstall monokai  # uninstalls a theme
      pry-theme convert -m 16 -t 3 # converts a single color to a term color
      pry-theme edit zenburn       # opens Zenburn theme in `Pry.editor`
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
          elsif color_model_option_and_other_one?(opts) || without_color_model?(opts)
            convert_color(opts, args)
          else
            output.puts 'You must provide the `-m` and one of the rest switches.'
            examples = [
              'pry-theme convert --model 8 --term 2',
              'pry-theme convert --model 8 --rgb 103,104,0',
              'pry-theme convert --model 16 --hex #EEAA00',
              'pry-theme convert --model 16 --term 0',
              'pry-theme convert --model 256 --term 255',
              'pry-theme convert --model 256 --hex #EEAA00',
            ]
            output.puts "Example: #{ examples[rand(examples.size)] }"
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
        opt.description 'Show information about currently active theme'

        opt.on :c, :colors, 'Display a painted code snippet'

        opt.run do |opts, args|

          if opts.present?(:c)
            _pry_.pager.page Preview.new(ThemeList.current_theme).long
          elsif args.empty?
            output.puts ThemeList.current_theme.name
          end
        end
      end
    end

    def def_edit(cmd)
      cmd.command :edit do |opt|
        opt.description 'Edit a theme definition'

        opt.run do |opts, args|
          BasicEditor.edit(args.first || ThemeList.current_theme.name)
        end
      end
    end

    def subcommands(cmd)
      [:def_list, :def_colors, :def_try, :def_edit,
       :def_uninstall, :def_install, :def_current, :def_convert,
      ].each { |m| __send__(m, cmd) }

      cmd.add_callback(:empty) do
        _pry_.pager.page opts.help
      end
    end

    def process
      # "There's no emptiness in the life of a warrior. Everything is filled to
      # the brim. Everything is filled to the brim, and everything is equal."
    end

    def complete(so_far)
      PryTheme::ThemeList.themes.map(&:name)
    end

    private

    def display_colors(color_model)
      case color_model
      when 256 then _pry_.pager.page(ColorTable.t256)
      when 16  then _pry_.pager.page(ColorTable.t16)
      when 8   then _pry_.pager.page(ColorTable.t8)
      end
    end

    def show_local_list
      previews = ThemeList.themes.map { |theme| Preview.new(theme).short }
      _pry_.pager.page(previews.join("\n"))
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
      _pry_.pager.page(out.chomp)
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

    def windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def install_theme(args)
      args.each { |theme|
        output.puts %|Installing "#{ theme }" from Pry Theme Collection...|
        body = json_body(PTC + "%s/%s#{ PT_EXT }" % [theme, theme])

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
      output.puts ColorTable.build_color_string(color)
    rescue NameError
      output.puts %|Unknown color model "#{ opts[:m] }". Try 8, 16 or 256|
    end

    def color_model_option_only?(opts)
      opts[:m] && !(opts[:h] || opts[:r] || opts[:t])
    end

    def color_model_option_and_other_one?(opts)
      opts[:m] && (opts[:h] || opts[:r] || opts[:t])
    end

    def without_color_model?(opts)
      !opts[:m] && (opts[:h] || opts[:r] || opts[:t])
    end

    def installed?(theme)
      theme['name'] == 'README.md' ||
        ThemeList.themes.map(&:name).include?(theme['name'])
    end
  end

  Pry::Commands.add_command(PryTheme::Command::PryTheme)
end
