module PryTheme
  class Preview
    def initialize(theme)
      @theme = theme
    end

    def short
      cur_theme = ThemeList.current_theme
      @theme.activate
      [header, description, '--', short_snippet].join("\n")
    ensure
      @theme.disable
      cur_theme.activate
    end

    def long
      long_snippet
    end

    def description
      @theme.description
    end

    def header
      Pry::Helpers::Text.bold("#{ @theme.name } / #{ @theme.color_model }")
    end

    private

    def short_snippet
      code = Pry::Helpers::CommandHelpers.unindent(<<-'CODE')
        1: class Theme
        2:   def method
        3:     @ivar, @@cvar, lvar = 10_000, 400.00, "string"
        4:   end
        5: end
      CODE
      Pry::Helpers::BaseHelpers.colorize_code(code)
    end

    def long_snippet
      code = Pry::Helpers::CommandHelpers.unindent(<<-CODE)
        # "#{ @theme.name }" theme.
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
      CODE
      Pry::Helpers::BaseHelpers.colorize_code(code)
    end
  end
end
