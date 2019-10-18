module PryTheme
  class Theme

    # @since 0.2.0
    # @api private
    module DynamicMethod
      def def_dynamic_methods(*dynamic_methods)
        dynamic_methods.each { |attr|
          define_method(attr) do |*args|
            name = :"@#{ attr }"
            if args.first
              decl =
                Color::Declaration.t(args, instance_variable_get(:@color_model))
              instance_variable_set(name, decl)
            end
            instance_variable_get(name)
          end
        }
      end
    end

    # @since 0.2.0
    # @api private
    module DefaultAttrs
      def set_default_attrs(attrs)
        default_color = PryTheme.const_get(:"Color#{ @color_model }").new
        attrs.each do |attr|
          instance_variable_set(:"@#{ attr }", default_color.dup)
        end
      end

      def set_nested_attrs
        regexp { set_default_attrs(Definition::Regexp::ATTRS) }
        shell  { set_default_attrs(Definition::Shell::ATTRS)  }
        string { set_default_attrs(Definition::String::ATTRS) }
      end

      def method_missing(meth, *args, &block)
        raise PryTheme::ThemeError, %|unknown option "#{ meth }"|
      end
    end

    # @since 0.2.0
    # @api private
    # @todo: possibly, try to avoid duplication.
    class Definition
      extend DynamicMethod
      include DefaultAttrs

      ATTRS = [
        :class_, :class_variable, :comment, :constant, :error, :float,
        :global_variable, :inline_delimiter, :instance_variable, :integer,
        :keyword, :method, :predefined_constant, :symbol
      ]

      def_dynamic_methods(*ATTRS)

      def initialize(color_model, &block)
        @color_model = color_model
        set_default_attrs(ATTRS) and set_nested_attrs
        instance_eval(&block)
      end

      def regexp(&block)
        @regexp = Definition::Regexp.new(@color_model, &block) if block_given?
        @regexp
      end

      def shell(&block)
        @shell = Definition::Shell.new(@color_model, &block) if block_given?
        @shell
      end

      def string(&block)
        @string = Definition::String.new(@color_model, &block) if block_given?
        @string
      end

      class Compound
        extend DynamicMethod
        include DefaultAttrs

        ATTRS = [:self_, :char, :content, :delimiter, :escape]

        def_dynamic_methods(*ATTRS)

        def initialize(color_model, &block)
          @color_model = color_model
          set_default_attrs(ATTRS)
          instance_eval(&block)
        end
      end

      class Regexp < Compound
        ATTRS = [:modifier]

        def_dynamic_methods(*ATTRS)

        def initialize(color_model, &block)
          @color_model = color_model
          set_default_attrs(ATTRS)
          super
        end
      end

      Shell = Class.new(Compound)
      String = Class.new(Compound)
    end

  end
end
