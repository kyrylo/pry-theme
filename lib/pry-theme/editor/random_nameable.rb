module PryTheme::Editor
  # Generates random words that are used to generate random theme names. The
  # words are made up of adjectives and nouns.
  module RandomNameable

    # @example
    #   generate_random_name #=> "bureaucratism"
    #   generate_random_name #=> "untheatrical"
    #   generate_random_name #=> "genus_leucogenes"
    def generate_random_name
      part_of_speech = [:adjs, :nouns].shuffle!.first
      RandomWord.__send__(part_of_speech).first
    end
    private :generate_random_name

  end
end
