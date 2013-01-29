module PryTheme

  # Raised when something goes wrong with Pry Theme themes. It's a general
  # exception for everything that comes into collision in theme files.
  ThemeError = Class.new(StandardError)

  # @since 0.2.0
  # @api private
  # @see PryTheme::create
  #
  # Creates a new Pry Theme theme. This class is not meant for the direct
  # instantiation. Use {PryTheme::create} instead.
  class Theme

    DEFAULT_CONFIG = {
      :name           => "prytheme-#{ rand(1_000_000_000) }",
      :color_model    => 256,
      :author         => 'Unknown Author',
      :description    => '',
    }

    # Matches against valid theme name. It must start with a letter. The letter
    # case is not important.
    VALID_NAME = /\A[A-z][A-z0-9-]*\z/i

    # @return [Theme::Definition] the heart of every theme: the colour
    #   definitions
    attr_reader :definition

    # @return [Boolean] whether this theme is a current theme
    attr_reader :active
    alias_method :active?, :active

    # @see PryTheme::create
    def initialize(config = {}, &block)
      @config = DEFAULT_CONFIG.merge(config)
      @authors = [{ :name => @config[:author] }]
      @default_author = true
      @active = false

      validate_config

      instance_eval(&block)
    end

    def author(options = nil)
      if options
        if options[:name].length > 32
          raise PryTheme::ThemeError,
            "author's name must be no longer than 32 characters"
        end

        if @default_author
          @default_author = false
          @authors[0] = options
        else
          @authors << options
        end
      end
      @authors
    end

    def description(text = nil)
      if text
        if text.length > 280
          raise PryTheme::ThemeError,
            "description must be no longer than 280 characters"
        end
        @config[:description] = text
      end
      @config[:description]
    end

    def define_theme(&block)
      @definition = Definition.new(color_model, &block)
    end

    def name
      @config[:name]
    end

    def color_model
      @config[:color_model]
    end

    def disable
      @active = false
    end

    def activate
      ::CodeRay::Encoders::Terminal::TOKEN_COLORS.merge!(to_coderay)
      @active = true
    end

    def to_coderay
      {}.tap do |coderay|
        @definition.class.instance_methods(false).each { |attr|
          attr = attr.to_sym
          val = @definition.__send__(attr) if @definition

          unless val.kind_of?(Color)
            coderay[attr] = {}
            ivars = val.instance_variables.delete_if { |v| v =~ /color_model/}
            ivars.each do |ivar|
              coderay[attr][ivar.to_s.chomp('_')[1..-1].to_sym] =
                val.instance_variable_get(ivar).to_ansi
            end
          else
            coderay[attr.to_s.chomp('_').to_sym] = val.to_ansi
          end
        }
      end
    end

    private

    def validate_config
      if name !~ VALID_NAME
        raise PryTheme::ThemeError, 'theme name must start with a letter'
      end

      if name.length > 18
        raise PryTheme::ThemeError,
          'theme name must be no longer than 18 characters'
      end

      unless [256, 8, 16].include?(color_model)
        raise PryTheme::ThemeError,
          'incorrect color model. Available values: 8, 16 or 256'
      end
    end

  end
end
