module PryTheme
  module ColorConverter

    extend self

    COLORS = Palette.new(256).colors

    def rgb_to_hex(rgb)
      "#%02x%02x%02x" % rgb.split(",")
    end

    def rgb_to_ansi(rgb)
      hex_to_ansi(rgb_to_hex(rgb))
    end

    def hex_to_rgb(hex)
      if m = hex.match(/\A#?([A-F\d]{2})([A-F\d]{2})([A-F\d]{2})\z/i)
        m.captures.map(&:hex)
      end
    end

    def hex_to_ansi(hex)
      rgb = hex_to_rgb(hex)

      unless Helper.rgb?(rgb.join(","))
        return
      end

      if color = RGB.table.index(rgb)
        return COLORS.find { |c| c.term == color }.term
      end

      increments = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]
      rgb.map! do |part|
        for i in (0..4)
          lower, upper = increments[i], increments[i+1]

          next unless part.between?(lower, upper)

          distance_from_lower = (lower - part).abs
          distance_from_upper = (upper - part).abs
          closest = distance_from_lower < distance_from_upper ? lower : upper
        end
        closest
      end

      COLORS.find { |c| c.term == RGB.table.index(rgb) }.term
    end

    def ansi_to_hex(ansi)
      "#" + RGB.table[ansi].map { |v| (v.to_s(16) * 2)[0...2] }.join
    end

  end
end
