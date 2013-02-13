module PryTheme::Editor
  # Represents a transparent RGB colour.
  class NoRGB

    def initialize
      @placeholder = 'transparent'
    end

    def inspect
      "(RGB: #@placeholder)"
    end

    def method_missing(method, *args, &block)
      @placeholder
    end

  end
end

