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
      PryTheme::RGB.new(PryTheme::RGB::TABLE[fg]) if fg
    end

    def parse_bg_color(attr)
      bg = attr.background
      PryTheme::RGB.new(PryTheme::RGB::TABLE[bg]) if bg
    end

    def parse_font_style(attr)
      'italic' if attr.italic?
    end

    def parse_font_weight(attr)
      'bold' if attr.bold?
    end

    def parse_text_decoration(attr)
      'underline' if attr.underline?
    end

  end
end
