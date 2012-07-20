module PryTheme
  module TermNotation

    # The prefix for 256-color ANSI foreground codes.
    COLOR256 = "38;5;"

    # The prefix for 256-color ANSI background codes.
    BACKGROUND256 = "48;5;"

    # The prefix for displaying a text only with a background color.
    NO_FOREGROUND = "38;0"

    # The prefix represents an empty ANSI code (used to please CodeRay).
    EMPTY = "38;0;0"

  end
end
