module PryTheme
  module Formatting
    ATTRIBUTES = {
      "b" => "1", # Bold.
      "u" => "4", # Underline.
      "i" => "7", # Inverse.
      "d" => "10" # Default.
    }

    BACKGROUNDS = {
      "black"   => "40",
      "red"     => "41",
      "green"   => "42",
      "yellow"  => "43",
      "blue"    => "44",
      "magenta" => "45",
      "cyan"    => "46",
      "white"   => "47",
      "default" => "49",
    }
  end

  # Creates a new color.
  Color = Struct.new(:term, :human) do
    def to_term(notation)
      "\e[#{ notation }#{ term };7m#{ term }\e[0m:\e[#{ notation }#{ term }m#{ human }\e[0m"
    end
  end

  # Color palettes aka set of colors. Use 8 colors for limited terminals (like
  # `linux` or other pithecanthropic crap. Real men's choice is 256 colors).
  class Palette

    # @return [Array<Color>] The colors in the current palette.
    attr_reader :colors

    # @return [Integer] The number representing max number of colors in theme.
    attr_reader :color_depth

    # @return [String] The notation to be used in conversions to terminal.
    attr_reader :notation

    # @param [Integer] colors The number of colors to be used in the palette.
    def initialize(colors=8)
      @color_depth = colors.to_i
      @notation = "38;5;" if color_depth == 256

      init_palette = "init_#{@color_depth}_colors"

      if self.class.private_method_defined?(init_palette)
        palette = send(init_palette)
      else
        raise NoPaletteError, "There is no palette with #{colors} colors (try 8 or 256)"
      end

      @colors = palette[:term].zip(palette[:human]).map do |color|
        Color.new(*color)
      end
    end

    def to_a
      @colors.map { |c| c.to_term(@notation) }
    end

    private

    def init_8_colors
      {
        :term  => [ 30, 31, 32, 33, 34, 35, 36, 37],
        :human => [ :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white ]
      }
    end

    def init_256_colors
      {
        :term  => (0...256).to_a,
        :human => [ :black, :maroon, :toad_in_love, :olive, :navy_blue, :violet_eggplant, :teal, :silver, :gray, :red, :green, :yellow, :blue, :magenta, :cyan, :white, :black, :dark_indigo, :ultramarine01, :ultramarine02, :persian_blue01, :blue, :dark_spring_green, :dark_turquoise, :cerulean_grey01, :denim01, :royal_blue01, :royal_blue02, :toad_in_love01, :sea_green01, :teal01, :cerulean_grey02, :klein_blue, :azure01, :vert_de_pomme01, :jade01, :jade02, :robin_egg_blue01, :bondi_blue, :light_blue01, :vert_de_pomme02, :malachite01, :emerald01, :turquoise, :robin_egg_blue02, :electric01, :green, :spring_green01, :spring_green02, :mint_green01, :aquamarine01, :cyan, :flea_belly, :plum, :indigo, :purple01, :violet01, :persian_blue02, :khaki01, :wet_asphalt01, :seroburomalinovyj01, :denim02, :royal_blue03, :royal_blue04, :olive_drab, :fern_green, :slate_gray, :steel_blue, :cornflower_blue01, :azure02, :grass01, :emerald02, :sea_green02, :robin_egg_blue03, :bluish01, :light_blue02, :vert_de_pomme03, :pale_green01, :emerald03, :aquamarine02, :robin_egg_blue04, :sky01, :bright_green, :malachite02, :spring_green03, :chartreuse01, :aquamarine03, :cyan01, :maroon01, :eggplant01, :violet_eggplant01, :purple02, :violet02, :violet03, :khaki02, :pale_mauve01, :seroburomalinovyj02, :amethyst01, :amethyst02, :heliotrope01, :olive01, :dark_tan, :gray01, :bluish02, :cornflower_blue02, :royal_blue05, :grass02, :asparagus, :swamp_green01, :light_grey01, :bluish03, :cornflower_blue03, :green_yellow01, :pale_green02, :emerald04, :celadon, :pale_blue01, :sky02, :viridian, :vert_de_pomme04, :mint_green02, :chartreuse02, :aquamarine04, :electric02, :bismarck_furious, :eggplant02, :red_violet01, :violet_eggplant02, :bright_violet, :violet04, :ochre, :pale_mauve02, :pale_red_violet01, :orchid01, :amethyst03, :heliotrope02, :dark_goldenrod, :pale_brown, :mountbatten_pink, :lilac01, :wisteria01, :amethyst04, :old_gold, :brass01, :swamp_green02, :light_grey02, :niagara, :wisteria02, :lime01, :pistachio01, :moss_green, :dark_tea_green, :pale_blue02, :pale_cornflower_blue, :green_yellow02, :green_yellow03, :pistachio02, :chartreuse03, :aquamarine05, :pale_blue03, :titian, :cerise01, :red_violet02, :hot_pink01, :bright_violet, :magenta01, :tenne, :chestnut01, :pale_red_violet02, :orchid02, :orchid03, :heliotrope03, :siena, :dark_salmon, :puce01, :puce2, :violaceous01, :violaceous02, :dark_pear, :brass02, :tan, :pale_chestnut, :lilac02, :wisteria03, :childs_surprise, :vert_de_peche, :flax, :gray_tea_green, :abdel_kerims_beard01, :periwinkle, :lime02, :pistachio03, :pistachio04, :tea_green01, :tea_green02, :pang, :red, :crimson, :cerise02, :hot_pink02, :hot_pink03, :magenta, :international_orange, :alizarin, :dark_pink01, :dark_pink02, :shocked_star, :fuchsia, :tangerine, :salmon, :chestnut02, :pale_red_violet03, :pale_magenta, :violaceous03, :orange, :pink_orange, :saumon, :pink01, :pink02, :violaceous04, :gold, :mustard01, :mustard02, :dark_peach, :pale_pink, :thistle, :yellow, :corn01, :corn02, :perhydor, :lemon_cream, :white, :black01, :black02, :black03, :bistre, :anthracite, :wet_asphalt02, :wet_asphalt03, :wet_asphalt04, :wet_asphalt05, :wet_asphalt06, :wet_asphalt07, :gray01, :gray, :gray02, :gray03, :gray04, :gray05, :light_grey03, :light_grey04, :silver01, :abdel_kerims_beard02, :abdel_kerims_beard03, :abdel_kerims_beard04, :seashell ]
      }
    end

  end

  class NoPaletteError < StandardError; end
  class NoColorError < StandardError; end
end
