module PryTheme
  class HEX

    # Represents a single HEX "digit".
    BYTE = /[A-F\d]{2}/i

    # A hex String must be prefixed with an octothorp. Use any letter case.
    PATTERN = /\A#(#{ BYTE }){3}\z/i

    # The key points that are used to calculate the nearest match of an RGB.
    BYTEPOINTS_256 = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]

    def initialize(value)
      validate_value(value)
      @value = value
    end

    def inspect
      "(HEX: #{ @value })"
    end

    def to_s
      @value
    end

    def to_rgb
      RGB.new(@value[1..-1].scan(BYTE).map! { |b| b.to_i(16) })
    end

    def to_term(color_model = 256)
      rgb  = to_rgb.to_a
      term = case color_model
             when 256 then PryTheme::RGB::TABLE.index(rgb)
             when 16  then PryTheme::RGB::SYSTEM.index(rgb)
             else raise ArgumentError,
                        "invalid value for PryTheme::HEX#to_term(): #{ rgb }"
             end
      if term.nil?
        rgb.map! { |byte| nearest_term_256(byte) }
        term = PryTheme::RGB::TABLE.index(rgb)
        term = nearest_term_16(term) if color_model == 16 && term > 15
      end
      PryTheme::TERM.new(term, color_model)
    end

    private

    def validate_value(value)
      unless value.is_a?(String)
        raise TypeError, "can't convert #{ value.class } into PryTheme::HEX"
      end
      if value !~ PryTheme::HEX::PATTERN
        raise ArgumentError, %|invalid value for PryTheme::HEX#new(): "#{ value }"|
      end
      true
    end

    def nearest_term_256(byte)
      for i in 0..4
        lower = BYTEPOINTS_256[i]
        upper = BYTEPOINTS_256[i + 1]
        next unless byte.between?(lower, upper)
        distance_from_lower = (lower - byte).abs
        distance_from_upper = (upper - byte).abs
        closest = distance_from_lower < distance_from_upper ? lower : upper
      end
      closest
    end

    # Oh, come on. At least it works!
    # TODO: use more realistic algorithm.
    def nearest_term_16(byte)
      byte / 16
    end

  end
end
