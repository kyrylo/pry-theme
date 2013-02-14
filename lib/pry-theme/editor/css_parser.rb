module PryTheme::Editor
  module CSSParser
    extend self

    NESTED_SELECTORS = [
      'regexp', 'shell', 'string', 'regexp .char', 'regexp .content',
      'regexp .delimiter', 'regexp .modifier', 'shell .char', 'shell .content',
      'shell .delimiter', 'string .char', 'string .content', 'string .delimiter'
    ]

    SELECTORS = NESTED_SELECTORS + %W{
      class class-variable comment constant error float global-variable error
      float global-variable inline-delimiter instance-variable integer keyword
      function predefined-constant symbol }

    def parse(definition)
      sels = SELECTORS.map { |selector|
        Stylesheet.new(selector) do |s|
          attr = if NESTED_SELECTORS.include?(selector)
                   find_nested_attr_by_selector(definition, selector)
                 else
                   find_attr_by_selector(definition, selector)
                 end
          s.color = parse_fg_color(attr)
          s.background_color = parse_bg_color(attr)
          s.font_style = parse_font_style(attr)
          s.font_weight = parse_font_weight(attr)
          s.text_decoration = parse_text_decoration(attr)
        end
      }
    end

    private

    def find_attr_by_selector(definition, selector)
      sel = selector.sub('-', '_')
      sel += '_' if sel == 'class' || sel == 'self'
      sel = 'method' if sel == 'function'
      definition.__send__(sel)
    end

    def find_nested_attr_by_selector(definition, selector)
      if selector =~ /(.+)\s(.+)/
        definition.__send__($1).__send__($2[1..-1])
      else
        definition.__send__(selector).self_
      end
    end

    def parse_fg_color(attr)
      fg = attr.foreground
      if fg
        color_code =
          case attr.color_model
          when 256
            PryTheme::RGB::TABLE[fg]
          when 16
            if fg.is_a?(String)
              fg, remainder = fg.split(';').map!(&:to_i)
            end

            if remainder
              PryTheme::RGB::SYSTEM[fg - 22]
            else
              PryTheme::RGB::SYSTEM[fg - 30]
            end
          when 8
            then PryTheme::RGB::LINUX[fg - 30]
          end
        PryTheme::RGB.new(color_code)
      end
    end

    def parse_bg_color(attr)
      bg = attr.background
      if bg
        color_code =
          case attr.color_model
          when 256
            PryTheme::RGB::TABLE[bg]
          when 16
            bg = bg.split(';').first.to_i if bg.is_a?(String)
            PryTheme::RGB::SYSTEM[bg - 40]
          when 8
            then PryTheme::RGB::LINUX[bg - 40]
          end
        PryTheme::RGB.new(color_code)
      end
    end

    def parse_font_style(attr)
      'italic' if attr.color_model == 256 && attr.italic?
    end

    def parse_font_weight(attr)
      if (attr.color_model == 256 && attr.bold?) ||
        (attr.color_model == 16 && attr.foreground.is_a?(String))
        'bold'
      end
    end

    def parse_text_decoration(attr)
      'underline' if attr.color_model == 256 && attr.underline?
    end

  end
end
