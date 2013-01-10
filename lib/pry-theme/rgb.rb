module PryTheme
  # @since 0.2.0
  # @api private
  #
  # Represents an RGB colour. It's possible to convert an RGB instance into
  # {HEX} or {TERM} colours. However, this conversion is half-duplex. If an RGB
  # instance gets converted to {TERM} format, there is a high chance that it
  # will be approximated to fit in range of colour model (colour model can be
  # set via an argument of the conversion method). This class validates its
  # input (you won't see malformed of nonexistent RGB colours).
  #
  # @example Conversion to HEX
  #   RGB.new([0, 0, 0]).to_hex #=> (HEX: #000000)
  # @example Conversion to TERM
  #   RGB.new([0, 0, 0]).to_term(8) #=> (TERM-8: 0)
  #
  #   # Approximation.
  #   RGB.new([254, 244, 231]).to_term(8) #=> (TERM-8: 7)
  class RGB

    # 8 colours. For the standard GNU/Linux terminal emulator.
    LINUX = [
      [  0,   0,   0], [128,   0,   0], [  0, 128,   0],
      [128, 128,   0], [  0,   0, 128], [128,   0, 128],
      [  0, 128, 128], [192, 192, 192]
    ]

    # 16 colours. For cmd.exe on Windows and other miserable terminals.
    SYSTEM = [
      *LINUX,
      [128, 128, 128], [255,   0,   0], [  0, 255,   0], [255, 255,   0],
      [  0,   0, 255], [255,   0, 255], [  0, 255, 255], [255, 255, 255]
    ]

    # The next 216 colours. For men.
    COLORS = [
      [  0,   0,   0], [  0,   0,  95], [  0,   0, 135], [  0,   0, 175],
      [  0,   0, 215], [  0,   0, 255], [  0,  95,   0], [  0,  95,  95],
      [  0,  95, 135], [  0,  95, 175], [  0,  95, 215], [  0,  95, 255],
      [  0, 135,   0], [  0, 135,  95], [  0, 135, 135], [  0, 135, 175],
      [  0, 135, 215], [  0, 135, 255], [  0, 175,   0], [  0, 175,  95],
      [  0, 175, 135], [  0, 175, 175], [  0, 175, 215], [  0, 175, 255],
      [  0, 215,   0], [  0, 215,  95], [  0, 215, 135], [  0, 215, 175],
      [  0, 215, 215], [  0, 215, 255], [  0, 255,   0], [  0, 255,  95],
      [  0, 255, 135], [  0, 255, 175], [  0, 255, 215], [  0, 255, 255],
      [ 95,   0,   0], [ 95,   0,  95], [ 95,   0, 135], [ 95,   0, 175],
      [ 95,   0, 215], [ 95,   0, 255], [ 95,  95,   0], [ 95,  95,  95],
      [ 95,  95, 135], [ 95,  95, 175], [ 95,  95, 215], [ 95,  95, 255],
      [ 95, 135,   0], [ 95, 135,  95], [ 95, 135, 135], [ 95, 135, 175],
      [ 95, 135, 215], [ 95, 135, 255], [ 95, 175,   0], [ 95, 175,  95],
      [ 95, 175, 135], [ 95, 175, 175], [ 95, 175, 215], [ 95, 175, 255],
      [ 95, 215,   0], [ 95, 215,  95], [ 95, 215, 135], [ 95, 215, 175],
      [ 95, 215, 215], [ 95, 215, 255], [ 95, 255,   0], [ 95, 255,  95],
      [ 95, 255, 135], [ 95, 255, 175], [ 95, 255, 215], [ 95, 255, 255],
      [135,   0,   0], [135,   0,  95], [135,   0, 135], [135,   0, 175],
      [135,   0, 215], [135,   0, 255], [135,  95,   0], [135,  95,  95],
      [135,  95, 135], [135,  95, 175], [135,  95, 215], [135,  95, 255],
      [135, 135,   0], [135, 135,  95], [135, 135, 135], [135, 135, 175],
      [135, 135, 215], [135, 135, 255], [135, 175,   0], [135, 175,  95],
      [135, 175, 135], [135, 175, 175], [135, 175, 215], [135, 175, 255],
      [135, 215,   0], [135, 215,  95], [135, 215, 135], [135, 215, 175],
      [135, 215, 215], [135, 215, 255], [135, 255,   0], [135, 255,  95],
      [135, 255, 135], [135, 255, 175], [135, 255, 215], [135, 255, 255],
      [175,   0,   0], [175,   0,  95], [175,   0, 135], [175,   0, 175],
      [175,   0, 215], [175,   0, 255], [175,  95,   0], [175,  95,  95],
      [175,  95, 135], [175,  95, 175], [175,  95, 215], [175,  95, 255],
      [175, 135,   0], [175, 135,  95], [175, 135, 135], [175, 135, 175],
      [175, 135, 215], [175, 135, 255], [175, 175,   0], [175, 175,  95],
      [175, 175, 135], [175, 175, 175], [175, 175, 215], [175, 175, 255],
      [175, 215,   0], [175, 215,  95], [175, 215, 135], [175, 215, 175],
      [175, 215, 215], [175, 215, 255], [175, 255,   0], [175, 255,  95],
      [175, 255, 135], [175, 255, 175], [175, 255, 215], [175, 255, 255],
      [215,   0,   0], [215,   0,  95], [215,   0, 135], [215,   0, 175],
      [215,   0, 215], [215,   0, 255], [215,  95,   0], [215,  95,  95],
      [215,  95, 135], [215,  95, 175], [215,  95, 215], [215,  95, 255],
      [215, 135,   0], [215, 135,  95], [215, 135, 135], [215, 135, 175],
      [215, 135, 215], [215, 135, 255], [215, 175,   0], [215, 175,  95],
      [215, 175, 135], [215, 175, 175], [215, 175, 175], [215, 175, 215],
      [215, 175, 255], [215, 215,   0], [215, 215,  95], [215, 215, 135],
      [215, 215, 175], [215, 215, 215], [215, 215, 255], [215, 255,   0],
      [215, 255,  95], [215, 255, 135], [215, 255, 175], [215, 255, 215],
      [215, 255, 255], [255,   0,   0], [255,   0,  95], [255,   0, 135],
      [255,   0, 175], [255,   0, 215], [255,   0, 255], [255,  95,   0],
      [255,  95,  95], [255,  95, 135], [255,  95, 175], [255,  95, 215],
      [255,  95, 255], [255, 135,   0], [255, 135,  95], [255, 135, 135],
      [255, 135, 175], [255, 135, 215], [255, 135, 255], [255, 175,   0],
      [255, 175,  95], [255, 175, 135], [255, 175, 175], [255, 175, 215],
      [255, 175, 255], [255, 215,   0], [255, 215,  95], [255, 215, 135],
      [255, 215, 175], [255, 215, 215], [255, 215, 255], [255, 255,   0],
      [255, 255,  95], [255, 255, 135], [255, 255, 175], [255, 255, 215]
    ]

    # The next 16 colours. For zen.
    GREYSCALE = (0x08..0xEE).step(0x0A).map { |v| [v] * 3 }

    # Combine everything into a full featured 256 colour RGB model.
    TABLE = SYSTEM + COLORS + GREYSCALE

    # The key points that are used to calculate the nearest match of an RGB.
    BYTEPOINTS_256 = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]

    private_constant :COLORS, :GREYSCALE, :BYTEPOINTS_256

    # @param [Array<Integer>, String] value a String will be converted to Array
    # @raise [TypeError] if the +value+ is neither Array or String
    def initialize(value)
      @value =
        case value
        when Array
          validate_array(value)
          value
        when String
          validate_array(value = value.scan(/\d+/).map!(&:to_i))
          value
        else
          raise TypeError, "can't convert #{ value.class } into PryTheme::RGB"
        end
    end

    # @return [String]
    def inspect
      "(RGB: #{ to_s })"
    end

    # Converts the RGB to a terminal colour equivalent.
    #
    # @note Accepts the following numbers: 256, 16, 8.
    # @param [Integer] color_model
    # @raise [ArgumentError] if +color_model+ parameter is incorrect
    # @return [TERM] a TERM representation of the RGB
    def to_term(color_model = 256)
      term = case color_model
             when 256 then PryTheme::RGB::TABLE.index(@value)
             when 16  then PryTheme::RGB::SYSTEM.index(@value)
             when 8   then PryTheme::RGB::LINUX.index(@value)
             else raise ArgumentError,
                        "invalid value for PryTheme::HEX#to_term(): #{ @value }"
             end
      term = find_among_term_colors(term, color_model) if term.nil?
      PryTheme::TERM.new(term, color_model)
    end

    # Converts the RGB to a HEX colour equivalent.
    # @return [HEX] a HEX representation of the RGB
    def to_hex
      PryTheme::HEX.new("#%02x%02x%02x" % @value)
    end

    # @example
    #   RGB.new([0, 12, 255]).to_s #=> "0, 12, 255"
    # @return [String]
    def to_s
      @value.join(', ')
    end

    # @example
    #   RGB.new([0, 12, 255]).to_s #=> [0, 12, 255]
    # @return [Array<Integer>]
    def to_a
      @value
    end

    private

    # Checks whether the +ary+ has correct number of elements and these elements
    # are valid RGB numbers.
    #
    # @param [Array<Integer>] ary
    # @raise [ArgumentError] if the +ary+ is invalid
    # @return [void]
    def validate_array(ary)
      correct_size = ary.size.equal?(3)
      correct_vals = ary.all?{ |val| val.is_a?(Fixnum) && val.between?(0, 255) }
      return true if correct_size && correct_vals
      raise ArgumentError,
            %|invalid value for PryTheme::RGB#validate_array(): "#{ ary }"|
    end

    # Approximates the given +byte+ to a terminal colour value within range of
    # 256 colours.
    #
    # @param [Integer] byte a number between 0 and 255
    # @return [Integer] approximated number
    def nearest_term_256(byte)
      for i in 0..4
        lower, upper = BYTEPOINTS_256[i], BYTEPOINTS_256[i + 1]
        next unless byte.between?(lower, upper)

        distance_from_lower = (lower - byte).abs
        distance_from_upper = (upper - byte).abs
        closest = distance_from_lower < distance_from_upper ? lower : upper
      end
      closest
    end

    # The same as {#nearest_term_256}, but returns a number beteen 0 and 15.
    #
    # @note Oh, come on. At least it works!
    # @todo use more realistic algorithm.
    def nearest_term_16(byte)
      byte / 16
    end

    # The same as {#nearest_term_256}, but returns a number beteen 0 and 7.
    #
    # @note Oh, come on. At least it works!
    # @todo use more realistic algorithm.
    def nearest_term_8(byte)
      byte / 32
    end

    # Finds an approximated +term+ colour among the colour numbers within the
    # given +color_model+.
    #
    # @param [Integer] term a colour to be approximated
    # @param [Integer] color_model possible values {#to_term}
    # @return [Integer] approximated number, which fits in range of color_model
    def find_among_term_colors(term, color_model)
      rgb = @value.map { |byte| nearest_term_256(byte) }
      term = PryTheme::RGB::TABLE.index(rgb)
      approximate(term, color_model)
    end

    # Approximates +term+ in correspondence with +color_model+
    #
    # @see #nearest_term_16
    # @see #nearest_term_8
    # @param [Integer] term a colour to be approximated
    # @param [Integer] color_model possible values {#to_term}
    # @return [Integer] approximated number, which fits in range of color_model
    def approximate(term, color_model)
      needs_approximation = (term > color_model - 1)

      if needs_approximation
        case color_model
        when 16 then nearest_term_16(term)
        when 8  then nearest_term_8(term)
        end
      else
        term
      end
    end

  end
end
