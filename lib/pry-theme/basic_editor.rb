require 'etc'

module PryTheme
  class BasicEditor

    class << self
      def edit(theme_name)
        editor = new(theme_name)
        editor.start
      end
    end

    attr_reader :current_file, :output

    def initialize(filename)
      @filename = filename
      theme_path = themify(filename)

      @editor = Pry.config.editor
      @new_theme = false
      @output = Pry.output
      @current_file = File.open(theme_path, 'r+')
    rescue Errno::ENOENT
      @new_theme = true
      @current_file = File.open(theme_path, 'w')
    end

    def start
      if @new_theme
        @output.puts 'Created a new theme.'
        @current_file.puts template
      end
      @output.puts "Opened in #{ @editor }: #{ themify(@filename) }"

      Pry::Editor.invoke_editor(@current_file.path, 1)
    ensure
      @current_file.close
    end

    private

    def reload_theme
      ThemeList.themes.delete_if { |theme| theme.name == @filename }
      load @current_file
    end

    def themify(filename)
      File.join(USER_THEMES_DIR, filename + PT_EXT)
    end

    def template
      Pry::Helpers::CommandHelpers.unindent(<<-TEMPLATE)
        t = PryTheme.create :name => '#{ @filename }' do
          author :name => '#{ Etc.getlogin || 'me' }', :email => 'user@hostname'
          description '#{ @filename } theme'

          # How the flip do I edit this?!
          # Help is there: https://github.com/kyrylo/pry-theme/wiki/Creating-a-New-Theme
          define_theme do
            class_
            class_variable
            comment
            constant
            error
            float
            global_variable
            inline_delimiter
            instance_variable
            integer
            keyword
            method
            predefined_constant
            symbol

            regexp do
              self_
              char
              content
              delimiter
              modifier
              escape
            end

            shell do
              self_
              char
              content
              delimiter
              escape
            end

            string do
              self_
              char
              content
              delimiter
              escape
            end
          end
        end

        PryTheme::ThemeList.add_theme(t)
      TEMPLATE
    end

  end
end
