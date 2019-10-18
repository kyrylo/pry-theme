module PryTheme
  class Color

    # @since 0.2.0
    # @api private
    class Declaration

      class << self
        def translate(decl, color_model)
          decl = Declaration.new(decl, color_model)
          decl.parse
          decl.to_color
        end
        alias_method :t, :translate
      end

      def initialize(color_decl, color_model)
        validate_effects(color_decl, color_model)

        @color_decl  = color_decl
        @color_model = color_model
        @color_class = PryTheme.const_get(:"Color#{ color_model }")
        @effects     = {}
        @parsed      = false
        @fg          = nil
        @bg          = nil
      end

      def parse
        if @parsed
          return
        else
          case @color_decl.size
          when 3 then build_from_two_layers
          when 2 then build_from_two_args
          when 1 then build_from_arg
          end
          @parsed = true
        end
      end

      def to_color
        [:readable, :hex, :rgb, :term].each do |type|
          begin
            return @color_class.new({
              :from => type,
              :foreground => @fg,
              :background => @bg
            }.merge!(@effects))
          rescue ArgumentError, TypeError
            next
          end
        end
        raise PryTheme::ThemeError,
          %|malformed color declaration (#{ [@fg, @bg].compact.join(', ') })|
      end

      private

      def validate_effects(color_decl, color_model)
        incorrect_color_model = (color_model != 256)
        incorrect_declaration = (color_decl.any? do |decl|
          decl.is_a?(Array) && decl.all? { |elem| elem.is_a?(Symbol) }
        end)

        if incorrect_color_model && incorrect_declaration
          raise PryTheme::ThemeError,
            'effects are available only for 256-color themes'
        end
      end

      def build_effects
        if @color_decl.any?
          @effects = @color_decl.shift.inject({}) { |h, k| h[k] = true; h }
        end
      end

      def build_from_two_layers
        @fg, @bg = 2.times.map { @color_decl.shift }
        build_effects
      end

      def build_from_two_args
        if decl_has_bg_key?
          @bg = @color_decl.first[:bg]
          @color_decl.shift
        else
          @fg = @color_decl.shift
          if @color_decl.last.is_a?(Array)
            @bg = @color_decl.shift if decl_contains_rgb?
          else
            @bg = @color_decl.shift
          end
        end
        build_effects
      end

      def build_from_arg
        f = @color_decl.first
        if decl_has_bg_key?
          @bg = f[:bg]
          @color_decl.shift
        elsif f.is_a?(String) || f.is_a?(Integer)
          @fg = @color_decl.shift
        else
          build_effects
        end
      end

      def decl_has_bg_key?
        f = @color_decl.first
        f.is_a?(Hash) && f.has_key?(:bg)
      end

      def decl_contains_rgb?
        l = @color_decl.last
        l.size == 3 && l.all? { |decl| decl.is_a?(Integer) }
      end

    end
  end
end
