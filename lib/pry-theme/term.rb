module PryTheme
  class TERM
    attr_reader :color_model

    def initialize(value, color_model = 256)
      validate_attrs(value, color_model)
      @value = value
      @color_model = color_model
    end

    def to_i
      @value
    end

    private

    def validate_attrs(value, color_model)
      fixnums = value.is_a?(Fixnum) && color_model.is_a?(Fixnum)
      if fixnums
        correct_term =
          case color_model
          when 256 then value.between?(0, 255)
          when 16  then value.between?(0, 15)
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
