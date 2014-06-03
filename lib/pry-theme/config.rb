module PryTheme
  module Config
    # @note The method amends the default behaviour of CodeRay.
    #
    # Sets the colour of the key token to the colour of the symbol token (akin to
    # Pygments).
    # @example
    #   {foo: 1, :bar => 2}
    #   #  ^       ^
    #   #  |       |
    #   # key    symbol
    # Without this patch keys and symbols have generally different colours. It's
    # impossible to set the colour of the key token, but with help of this method
    # you can make it look like a symbol.
    # @return [void]
    # @see https://github.com/kyrylo/pry-theme/issues/30
    def self.paint_key_as_symbol!
      token_colors = CodeRay::Encoders::Terminal::TOKEN_COLORS
      token_colors[:key] = token_colors[:symbol]
    end
  end
end
