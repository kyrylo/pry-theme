module PryTheme::Editor
  class CodePlate

    include PryTheme::Editor::RandomNameable

    def initialize(definition, name = generate_random_name)
      @stylesheets = PryTheme::Editor::CSSParser.parse(definition)
      @name        = name
      @facade      = DEFAULT_FACADE
      @rendered    = false
    end

    def render
      return @facade if @rendered
      CodeRay::Styles::Alpha::TOKEN_COLORS.replace(@stylesheets.map(&:css).join("\n"))
      @rendered = true
      @facade = CodeRay.scan(@facade, :ruby).div
    end

    DEFAULT_FACADE = Pry::Helpers::CommandHelpers.unindent(<<-CODE)
      module PryTheme
        # Kia ora, good morning or bonjour? Depends on you!
        class Greeter
          DEFAULT_TIME = 20_000 # Greets every N seconds.

          @@config = {
            :latency   => 100.5599,
            :address   => /[0-9][0-9] \#{Orange} St\\w+/xi,
            :recipient => %r{\\AJim{1,2}y?[0-9]}s,
            :bye_msg   => "\#@who said that\\nI should leave?"
            "\#{broken}" => @@@\\\\$ # Errror! Bzzt.
          }

          def self.greet!(msg = Message.new)
            condition = @condition || FALSE
            puts msg and return if msg.default?
            if condition
              $stdout.puts "Preparing to greet you!" if $DEBUG
              `echo "\#@hello \#{Merry} Christmas!\\n"`
            end
          end
    CODE

  end
end
