module PryTheme
  # @since 0.2.0
  # @api private
  #
  # Represents a terminal colour (not ANSI). Checks whether a number fits in its
  # colour model.
  class TERM

    # @return [Integer] the values are 8, 16 or 256
    attr_reader :color_model

    # @param [Integer] value
    # @param [Integer] color_model
    def initialize(value, color_model = 256)
      validate_attrs(value, color_model)
      @value = value
      @color_model = color_model
    end

    # @return [String]
    def inspect
      "(TERM-#{ @color_model }: #{ @value })"
    end

    # @return [Integer]
    def to_i
      @value
    end

    private

    # @param [Integer] value
    # @param [Integer] color_model
    # @raise [ArgumentError] if the +value+ isn't a valid Integer (not in
    #   +color_model+ range) or provided incorrect +color_model+
    # @raise [TypeError] if the +value+ or the +color_model+ isn't an Integer
    #   at all
    # @return [void]
    def validate_attrs(value, color_model)
      fixnums = value.is_a?(Fixnum) && color_model.is_a?(Fixnum)
      correct_term =
        if fixnums
          case color_model
          when 256 then value.between?(0, 255)
          when 16  then value.between?(0, 15)
          when 8   then value.between?(0, 7)
          else raise ArgumentError,
                    'invalid color model for PryTheme::TERM#new(): ' \
                    "\"#{ color_model }\""
          end
        end

      return true if fixnums && correct_term

      unless fixnums
        raise TypeError, "can't convert #{ value.class } into PryTheme::TERM"
      end

      unless correct_term
        raise ArgumentError,
          %|invalid TERM number for PryTheme::TERM#new(): "#{ value }"|
      end
    end

  end
end
