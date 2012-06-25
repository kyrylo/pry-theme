module PryTheme
  Commands = Pry::CommandSet.new do

    create_command "pry-theme", "Manage your Pry themes." do
      banner <<-BANNER
        Usage: pry-theme [OPTIONS]
          Change your theme on the fly.
          e.g.: pry-theme pry-classic
      BANNER

      def process
        unless args.empty?
          PryTheme::Setter.call(args[0])
        end
      end
    end

  end
end
