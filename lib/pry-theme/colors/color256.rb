require 'pry-theme/colors/color256/fg'

module PryTheme
  class Color256
    module Layer
      extend self

      def foreground(options)
        fg = FG[extract_options(options, :foreground)]
        if fg
          fg.is_a?(Array) ? fg.first : fg
        else
          false
        end
      end

      def background(options)
        bg = FG[extract_options(options, :background)]
        if bg
          bg.is_a?(Array) ? bg.first : bg
        else
          false
        end
      end

      private

      def extract_options(options, opt)
        if options[opt]
          value = case options[:from]
                  when :readable then options[opt]
                  when :hex      then HEX.new(options[opt]).to_term.to_i
                  when :rgb      then RGB.new(options[opt]).to_term.to_i
                  when :term     then TERM.new(options[opt]).to_i
                  end
        else
          value = options[opt]
        end

        unless value.is_a?(String)
          val = FG.find { |r, *t| t.flatten.include?(value) }
          value = val.first if val
        end

        if FG.has_key?(value) || value == false
          value
        else
          raise ArgumentError, %|invalid #{opt.to_s} value "#{ options[opt] }"|
        end
      end
    end

    OPTS = {
      :from       => :readable,
      :foreground => false,
      :background => false,
      :bold       => false,
      :italic     => false,
      :underline  => false,
    }

    private_constant :FG, :OPTS

    module Effects
      extend self

      LIST = {
        :bold      => 1,
        :italic    => 3,
        :underline => 4
      }

      def bold(options)
        options[:bold] && LIST[:bold]
      end

      def italic(options)
        options[:italic] && LIST[:italic]
      end

      def underline(options)
        options[:underline] && LIST[:underline]
      end
    end

    ANSI = Struct.new(:options) do
      def foreground
        Layer.foreground(options)
      end

      def background
        Layer.background(options)
      end

      def readable_fg
        options[:foreground]
      end

      def readable_bg
        options[:background]
      end

      def bold
        Effects.bold(options)
      end

      def italic
        Effects.italic(options)
      end

      def underline
        Effects.underline(options)
      end
    end

    def initialize(options = {})
      ansi = ANSI.new(OPTS.merge(options))
      @foreground  = ansi.foreground
      @background  = ansi.background
      @readable_fg = ansi.readable_fg
      @readable_bg = ansi.readable_bg
      @bold        = ansi.bold
      @italic      = ansi.italic
      @underline   = ansi.underline
    end

    def foreground(readable = false)
      readable ? @readable_fg : @foreground
    end

    def background(readable = false)
      readable ? @readable_bg : @background
    end

    def to_ansi
      fg, bg = !!foreground, !!background
      create_ansi_sequence(fg, bg)
    end

    def bold
      @bold
    end

    def bold?
      !!bold
    end

    def underline
      @underline
    end

    def underline?
      !!underline
    end

    def italic
      @italic
    end

    def italic?
      !!italic
    end

    private

    def create_ansi_sequence(fg, bg)
      (if fg && bg
        [*build_fg_sequence, *build_effects_sequence, *build_bg_sequence]
      elsif fg && !bg
        [*build_fg_sequence, *build_effects_sequence]
      elsif !fg && bg
        [*build_bg_sequence, *build_effects_sequence]
      else
        build_effects_sequence.tap { |sequence|
          sequence << '0' if sequence.empty?
        }
      end).join(';')
    end

    def build_fg_sequence
      ['38', '5', foreground]
    end

    def build_effects_sequence
      [bold, italic, underline].delete_if(&:!)
    end

    def build_bg_sequence
      ['48', '5', background]
    end
  end
end
