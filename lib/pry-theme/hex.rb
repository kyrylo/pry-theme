module PryTheme
  # @since 0.2.0
  # @api private
  #
  # Represents a HEX colour. It's possible to convert a HEX instance into {TERM}
  # or {RGB} colours. However, this conversion is half-duplex (see {RGB}). This
  # class validates its input (you won't see malformed or nonexistent HEX
  # colours).
  #
  # @note Conversion to {TERM} relies on {RGB#to_term}, as a {HEX} instance
  #   converts itself to {RGB} first, and only then to {TERM}.
  # @example Conversion to RGB
  #   HEX.new('#ffffff').to_rgb #=> (RGB: 255, 255, 255)
  # @example Conversion to TERM
  #   HEX.new('#ffffff').to_term(16) #=> (TERM-16: 15)
  #
  #   # Approximation.
  #   HEX.new('#fc33ea').to_term #=> (TERM-256: 207)
  class HEX

    # Represents a single HEX "digit".
    BYTE = /[A-F\d]{2}/i

    # A hex String must be prefixed with an octothorp. Use any letter case.
    PATTERN = /\A#(#{ BYTE }){3}\z/i

    # @param [String] value must be a valid hex number
    def initialize(value)
      validate_value(value)
      @value = value
    end

    # @return [String]
    def inspect
      "(HEX: #{ @value })"
    end

    # @example
    #   HEX.new('#33aabb').to_s #=> "#33aabb"
    # @return [String]
    def to_s
      @value
    end

    # Converts `self` into {RGB}.
    # @return [RGB]
    def to_rgb
      RGB.new(@value[1..-1].scan(BYTE).map! { |b| b.to_i(16) })
    end

    # Converts `self` into {TERM}.
    # @return [RGB]
    def to_term(color_model = 256)
      to_rgb.to_term(color_model)
    end

    private

    # Validates whether +value+ is a valid hex colour value.
    #
    # @param [String] value
    # @raise [TypeError] if +value+ isn't String
    # @raise [ArgumentError] if +value+ is malformed
    # @return [void]
    def validate_value(value)
      unless value.is_a?(String)
        raise TypeError, "can't convert #{ value.class } into PryTheme::HEX"
      end
      if value !~ PryTheme::HEX::PATTERN
        raise ArgumentError, %|invalid value for PryTheme::HEX#new(): "#{ value }"|
      end
      true
    end

  end
end
