require 'helper'

describe PryTheme::Command::PryTheme do
  before do
    theme = PryTheme.create(:name => 'wholesome'){}
    PryTheme::ThemeList.add_theme(theme)

    other_theme = PryTheme.create(:name => 'sick'){}
    PryTheme::ThemeList.add_theme(other_theme)
  end

  describe "empty callback" do
    it "outputs help" do
      pry_eval('pry-theme').should =~ /Usage: pry-theme/
    end
  end

  describe "'current' subcommand" do
    it "displays current theme name" do
      PryTheme::ThemeList.activate_theme('wholesome')
      pry_eval('pry-theme current').should == "wholesome\n"
    end

    it "displays the short summary about current theme" do
      PryTheme::ThemeList.activate_theme('wholesome')

      pry_eval('pry-theme current --colors').should ==
        Pry::Helpers::CommandHelpers.unindent(<<-'OUT')
        # "wholesome" theme.
        class PryTheme::ThisIsAClass
          def this_is_a_method
            THIS_IS_A_CONSTANT  = :this_is_a_symbol
            this_is_a_local_var = "#{this} #@is a string.\n"
            this_is_a_float     = 10_000.00
            this_is_an_integer  = 10_000

            # TRUE and FALSE are predefined constants.
            $this_is_a_global_variable = TRUE or FALSE

            @this_is_an_instance_variable = `echo '#@hi #{system} call\n'`
            @@this_is_a_class_variable    = @@@\\$ # An error.

            /[0-9]{1,3}this #{is} a regexp\w+/xi
          end
        end
      OUT
    end

    it "doesn't display anything" do
      pry_eval('pry-theme current --foo-bar').should == ''
    end
  end

  describe "'try' subcommand" do
    it "temporary switches to a theme" do
      pry_eval('pry-theme try sick').should == "Using \"sick\" theme\n"
      PryTheme::ThemeList.current_theme.name.should == 'sick'

      pry_eval('pry-theme try wholesome').should == "Using \"wholesome\" theme\n"
      PryTheme::ThemeList.current_theme.name.should == 'wholesome'
    end

    it "displays error message if can't find the given theme" do
      cur = PryTheme::ThemeList.current_theme.name
      pry_eval('pry-theme try g-system').
        should == %|Cannot find "g-system" amongst themes in #{PryTheme::USER_THEMES_DIR}\n|
      PryTheme::ThemeList.current_theme.name.should == cur
    end
  end

  describe "'list' subcommand" do
    it "lists currently installed themes" do
      pry_eval('pry-theme list').should =~ /class Theme/
      pry_eval('pry-theme list').should =~ /sick/
    end

    it "doesn't mangle current theme" do
      cur = PryTheme::ThemeList.current_theme
      pry_eval('pry-theme list')
      PryTheme::ThemeList.current_theme.should == cur
    end
  end

  describe "'colors' subcommand" do
    before { Pry.config.color = true }
    after { Pry.config.color = false }

    if ENV['TERM'] =~ /256color/
      it "displays colours accordingly to the terminal color support" do
        table = pry_eval('pry-theme colors')
        table.should =~ /silver01/
        table.should =~ /7;38;5;105/
      end
    end

    describe "colours according to the chosen model" do
      it "displays the table of 256 colours" do
        table = pry_eval('pry-theme colors -m 256')
        table.should =~ /silver01/
        table.should =~ /7;38;5;105/
        table.should.not =~ /bright_red/
      end

      it "displays the table of 16 colours" do
        table = pry_eval('pry-theme colors -m 16')
        table.should =~ /bright_red/
        table.should =~ /7;31;1/
        table.should.not =~ /silver01/
      end

      it "displays the table of 8 colours" do
        table = pry_eval('pry-theme colors -m 8')
        table.should =~ /red/
        table.should =~ /7;36/
        table.should.not =~ /silver01/
        table.should.not =~ /bright_red/
      end
    end
  end

  describe "'convert' subcommand" do
    if ENV['TERM'] =~ /256color/
      it "converts colours accordingly to the terminal color support" do
        pry_eval('pry-theme convert -t 124').should =~ /bismarck_furious/
      end
    end

    it "warns when no switches given" do
      pry_eval('pry-theme convert').should =~ /You must provide the `-m`/
    end

    it "warns on incorrect usage" do
      pry_eval('pry-theme convert dqwdwq').should =~ /You must provide the `-m`/
    end

    describe "conversion from term" do
      if PryTheme.tput_colors == 256
        it "with implicit model" do
          pry_eval('pry-theme convert -t 124').should =~ /bismarck_furious/
        end
      end

      it "with explicit color model 8" do
        pry_eval('pry-theme convert -m 8 -t 7').should =~ /white/
      end

      it "with explicit color model 16" do
        pry_eval('pry-theme convert -m 16 -t 10').should =~ /bright_green/
      end

      it "with explicit color model 256" do
        pry_eval('pry-theme convert -m 256 -t 124').should =~ /bismarck_furious/
      end
    end

    describe "conversion from rgb" do
      if PryTheme.tput_colors == 256
        it "with implicit model" do
          pry_eval('pry-theme convert -r 124,0,11').should =~ /maroon01/
        end
      end

      it "with explicit color model 8" do
        pry_eval('pry-theme convert -m 8 -r 124,0,11').should =~ /green/
      end

      it "with explicit color model 16" do
        pry_eval('pry-theme convert -m 16 -r 124,0,11').should =~ /magenta/
      end

      it "with explicit color model 256" do
        pry_eval('pry-theme convert -m 256 -r 124,0,11').should =~ /maroon01/
      end
    end

    describe "conversion from hex" do
      if PryTheme.tput_colors == 256
        it "with implicit model" do
          pry_eval('pry-theme convert -h #ae3aff').should =~ /heliotrope02/
        end
      end

      it "with explicit color model 8" do
        pry_eval('pry-theme convert -m 8 -h #ae3aff').should =~ /blue/
      end

      it "with explicit color model 16" do
        pry_eval('pry-theme convert -m 16 -h #ae3aff').should =~ /bright_black/
      end

      it "with explicit color model 256" do
        pry_eval('pry-theme convert -m 256 -h #ae3aff').should =~ /heliotrope02/
      end
    end

    describe "error handling" do
      it "outputs the error message if colour model was specified without a colour" do
        pry_eval('pry-theme convert -m 8').should =~ /Provide a color value/
      end

      it "outputs the error message if colour model is invalid" do
        pry_eval('pry-theme convert -m 23 -t 32').should =~ /Unknown color model/
      end
    end
  end
end
