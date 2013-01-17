module PryTheme
  module Layered

    def foreground
      fg = fg_hash[extract_options(options, :foreground)]
      if fg
        fg.is_a?(Array) ? fg.first : fg
      else
        false
      end
    end

    def background
      bg = fg_hash[extract_options(options, :background)]
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
        val = fg_hash.find { |r, *t| t.flatten.include?(value) }
        value = val.first if val
      end

      if fg_hash.has_key?(value) || value == false
        value
      else
        raise ArgumentError, %|invalid #{opt.to_s} value "#{ options[opt] }"|
      end
    end

    def fg_hash
      options[:fg].const_get(:FG)
    end

  end
end
