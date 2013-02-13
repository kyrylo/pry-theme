module PryTheme
  module Editor
    # Represents a CSS stylesheet. These stylesheets are pretty limited, because
    # PryTheme doesn't need the whole bunch of CSS properties. PryTheme supports
    # bold, italic, underline text; background and foreground.
    #
    # @example
    #   stylesheet = Stylesheet.new('.method') do |s|
    #     s.color = PryTheme::RGB.new([21, 0, 100])
    #     s.background_color = PryTheme::RGB.new([11, 255, 255])
    #     s.text_decoration = 'underline'
    #   end
    #
    #   puts stylesheet.css
    #   .method {
    #     color: rgb(21, 0, 100);
    #     background-color: rgb(11, 255, 255);
    #     font-style: normal;
    #     font-weight: normal;
    #     text-decoration: underline;
    #   }
    #   #=> nil
    class Stylesheet

      # @return [PryTheme::RGB] the "color" property from CSS
      attr_accessor :color

      # @return [PryTheme::RGB] the "background-color" property from CSS
      attr_accessor :background_color

      # @return [String] the "font-style" property from CSS
      attr_accessor :font_style

      # @return [String] the "font-weight" property from CSS
      attr_accessor :font_weight

      # @return [String] the "text-decoration" property from CSS
      attr_accessor :text_decoration

      # @return [String]
      attr_reader :selector

      # @param [String] selector The name of the stylesheet
      def initialize(selector)
        yield(self) if block_given?

        @selector = selector
        @color            ||= PryTheme::RGB.new([0, 0, 0])
        @background_color ||= PryTheme::Editor::NoRGB.new
        @font_style       ||= 'normal'
        @font_weight      ||= 'normal'
        @text_decoration  ||= 'none'
      end

      def css
        Pry::Helpers::CommandHelpers.unindent(<<-CSS)
          .#{ @selector } {
            color: #{ @color.to_css };
            background-color: #{ @background_color.to_css };
            font-style: #@font_style;
            font-weight: #@font_weight;
            text-decoration: #@text_decoration;
          }
        CSS
      end

    end
  end
end
