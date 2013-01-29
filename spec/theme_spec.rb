require 'helper'

describe PryTheme::Theme do
  describe "name option" do
    it "defaults to some value if it's not specified" do
      theme = PryTheme.create{}
      theme.name.should =~ /prytheme-\d+/
    end

    it "adds a theme name" do
      theme = PryTheme.create(:name => 'w00t'){}
      theme.name.should == 'w00t'
    end

    describe "validation" do
      it "ensures that the first character is a letter" do
        lambda { PryTheme.create(:name => '0ol'){} }.
          should.raise(PryTheme::ThemeError).
          message.should.match /must start with a letter/
      end

      it "ensures that the the length is no longer than 18 characters" do
        long_n = 'x' * 19
        lambda { PryTheme.create(:name => long_n){} }.
          should.raise(PryTheme::ThemeError).
          message.should.match /no longer than 18 characters/
      end
    end
  end

  describe "color model option" do
    it "defaults to some value if it's not specified" do
      theme = PryTheme.create{}
      theme.color_model.should == 256
    end

    it "adds color model" do
      theme = PryTheme.create(:color_model => 8){}
      theme.color_model.should == 8
    end

    describe "validation" do
      it "ensures that it's a correct number" do
        lambda { PryTheme.create(:name => 'w00t', :color_model => 255){} }.
          should.raise(PryTheme::ThemeError).
          message.should.match /incorrect color model/
      end
    end
  end

  describe "#author" do
    it "defaults to some value if it's not specified" do
      theme = PryTheme.create{}
      theme.author.first[:name].should == 'Unknown Author'
    end

    it "adds an author" do
      theme = PryTheme.create{ author(:name => 'Kvitka', :email => 'kvi@t.ka') }
      theme.author.first[:name].should == 'Kvitka'
      theme.author.first[:email].should == 'kvi@t.ka'
    end

    it "adds multiple authors" do
      theme = PryTheme.create{
        author(:name => 'Kvitka', :email => 'kvi@t.ka')
        author(:name => 'Cisyk', :email => 'ci@s.yk') }
      theme.author.first[:name].should == 'Kvitka'
      theme.author.first[:email].should == 'kvi@t.ka'
      theme.author.last[:name].should == 'Cisyk'
      theme.author.last[:email].should == 'ci@s.yk'
    end

    describe "validation" do
      it "ensures that the the length is no longer than 32 characters" do
        long_n = 'x' * 33
        lambda { PryTheme.create{ author(:name => long_n)} }.
          should.raise(PryTheme::ThemeError).
          message.should.match /no longer than 32 characters/
      end
    end
  end

  describe "#description" do
    it "defaults to some value if it's not specified" do
      theme = PryTheme.create{}
      theme.description.should == ''

    end

    it "adds description" do
      theme = PryTheme.create{ description('wub wub') }
      theme.description.should == 'wub wub'
    end

    describe "validation" do
      it "ensures that the the length is no longer than 280 characters" do
        long_d = 'x' * 281
        lambda { PryTheme.create{ description(long_d)} }.
          should.raise(PryTheme::ThemeError).
          message.should.match /no longer than 280 characters/
      end
    end
  end

  describe "definition" do
    describe "correct theme" do
      describe "with 8 colours" do
        it "sets foreground" do
          theme = PryTheme.create(:color_model => 8) {
            define_theme{ constant('blue') } }
          theme.definition.constant.foreground.should == 34
          theme.definition.constant.background.should == false
        end

        it "sets backround" do
          theme = PryTheme.create(:color_model => 8) {
            define_theme{ constant(:bg => 'blue') } }
          theme.definition.constant.foreground.should == false
          theme.definition.constant.background.should == 44
        end

        it "sets foreground and background" do
          theme = PryTheme.create(:color_model => 8) {
            define_theme{ symbol('blue', 'red') } }
          theme.definition.symbol.foreground.should == 34
          theme.definition.symbol.background.should == 41
        end

        it "defaults to proper colours" do
          theme = PryTheme.create(:color_model => 8){ define_theme{} }
          theme.definition.integer.to_ansi.should == '39;49'
        end
      end

      describe "with 16 colours" do
        it "sets foreground" do
          theme = PryTheme.create(:color_model => 16) {
            define_theme{ constant('bright_blue') } }
          theme.definition.constant.foreground.should == '34;1'
          theme.definition.constant.background.should == false
        end

        it "sets backround" do
          theme = PryTheme.create(:color_model => 16) {
            define_theme{ constant(:bg => 'bright_yellow') } }
          theme.definition.constant.foreground.should == false
          theme.definition.constant.background.should == 43
        end

        it "sets foreground and background" do
          theme = PryTheme.create(:color_model => 16) {
            define_theme{ symbol('blue', 'red') } }
          theme.definition.symbol.foreground.should == 34
          theme.definition.symbol.background.should == 41
        end

        it "defaults to proper colours" do
          theme = PryTheme.create(:color_model => 16){ define_theme{} }
          theme.definition.integer.to_ansi.should == '39;49'
        end
      end

      describe "with 256" do
        it "sets foreground" do
          theme = PryTheme.create(:color_model => 256) {
            define_theme{ constant('celadon') } }
          theme.definition.constant.foreground.should == 115
          theme.definition.constant.background.should == false
        end

        it "sets backround" do
          theme = PryTheme.create(:color_model => 256) {
            define_theme{ constant(:bg => 'viridian') } }
          theme.definition.constant.foreground.should == false
          theme.definition.constant.background.should == 118
        end

        it "sets foreground and background" do
          theme = PryTheme.create(:color_model => 256) {
            define_theme{ symbol('celadon', 'viridian') } }
          theme.definition.symbol.foreground.should == 115
          theme.definition.symbol.background.should == 118
        end

        it "defaults to proper colours" do
          theme = PryTheme.create(:color_model => 256){ define_theme{} }
          theme.definition.integer.to_ansi.should == '0'
        end

        describe "effects" do
          it "sets effects without layers" do
            theme = PryTheme.create(:color_model => 256) {
              define_theme{ symbol([:bold, :underline, :italic]) } }
            theme.definition.symbol.foreground.should == false
            theme.definition.symbol.background.should == false
            theme.definition.symbol.bold?.should == true
            theme.definition.symbol.underline?.should == true
            theme.definition.symbol.italic?.should == true
          end

          it "sets effects and foreground" do
            theme = PryTheme.create(:color_model => 256) {
              define_theme{ symbol('sky02', [:bold, :underline, :italic]) } }
            theme.definition.symbol.foreground.should == 117
            theme.definition.symbol.background.should == false
            theme.definition.symbol.bold?.should == true
            theme.definition.symbol.underline?.should == true
            theme.definition.symbol.italic?.should == true
          end

          it "sets effects and background" do
            theme = PryTheme.create(:color_model => 256) {
              define_theme{
                symbol({:bg => 'olive01'}, [:bold, :underline, :italic]) } }
            theme.definition.symbol.foreground.should == false
            theme.definition.symbol.background.should == 100
            theme.definition.symbol.bold?.should == true
            theme.definition.symbol.underline?.should == true
            theme.definition.symbol.italic?.should == true
          end

          it "sets effects, foreground and background" do
            theme = PryTheme.create(:color_model => 256) {
              define_theme{
                symbol('sky02', 'olive01', [:bold, :underline, :italic]) } }
            theme.definition.symbol.foreground.should == 117
            theme.definition.symbol.background.should == 100
            theme.definition.symbol.bold?.should == true
            theme.definition.symbol.underline?.should == true
            theme.definition.symbol.italic?.should == true
          end
        end
      end
    end

    describe "broken theme" do
      it "raises error when colour definition is malformed" do
        should.raise(PryTheme::ThemeError) {
          PryTheme.create{ define_theme { class_ 'wowzers' } }
        }.message.should =~ /malformed color declaration \(wowzers\)/
      end

      describe "with 8 colours" do
        it "doesn't allow effects" do
          lambda { PryTheme.create(:color_model => 8) {
            define_theme{ constant('blue', [:bold]) } } }.
          should.raise(PryTheme::ThemeError).
          message.should.match /effects are available only for 256-color themes/

          lambda { PryTheme.create(:color_model => 8) {
            define_theme{ constant({:fg => 'blue'}, [:bold]) } } }.
          should.raise(PryTheme::ThemeError).
          message.should.match /effects are available only for 256-color themes/


          lambda { PryTheme.create(:color_model => 8) {
            define_theme{ constant([:bold]) } } }.
          should.raise(PryTheme::ThemeError).
          message.should.match /effects are available only for 256-color themes/
        end
      end

      describe "with 16 colours" do
        it "doesn't allow effects" do
          lambda { PryTheme.create(:color_model => 16) {
            define_theme{ constant('blue', [:bold]) } } }.
          should.raise(PryTheme::ThemeError).
          message.should.match /effects are available only for 256-color themes/

          lambda { PryTheme.create(:color_model => 16) {
            define_theme{ constant({:fg => 'blue'}, [:bold]) } } }.
          should.raise(PryTheme::ThemeError).
          message.should.match /effects are available only for 256-color themes/

          lambda { PryTheme.create(:color_model => 16) {
            define_theme{ constant([:bold]) } } }.
          should.raise(PryTheme::ThemeError).
          message.should.match /effects are available only for 256-color themes/
        end
      end

      describe "non-existent options" do
        it "raises error" do
          lambda { PryTheme.create { define_theme { klass 'red' } } }.
            should.raise(PryTheme::ThemeError).
            message.should.match /unknown option "klass"/
        end
      end
    end
  end

  describe "nested definition" do
    it "doesn't conflict with other nested definitions" do
      theme = PryTheme.create(:color_model => 8) {
        define_theme{
          regexp{ self_ 'blue' }
          string{ self_ 'green'; delimiter 'black' } } }
      theme.definition.regexp.self_.foreground(true).should == 'blue'
      theme.definition.string.self_.foreground(true).should == 'green'
      theme.definition.regexp.modifier.to_ansi.should == '39;49'
      theme.definition.string.delimiter.foreground(true).should == 'black'
      theme.definition.regexp.delimiter.to_ansi.should == '39;49'
      theme.definition.shell.delimiter.to_ansi.should == '39;49'
    end
  end

  describe "a wholesome theme" do
    it "works with all options :-)" do
      lambda {
        PryTheme.create(:name => 'wholesome', :color_model => 8) {
          author :name => 'Kyrylo Silin', :email => 'kyrylosilin@gmail.com'
          description 'a kool theme!'
          define_theme {
            class_ 'magenta'
            class_variable 'cyan'
            comment 'blue'
            constant 'blue'
            error 'yellow', 'red'
            float 'magenta'
            global_variable :bg => 'green'
            inline_delimiter 'blue'
            instance_variable 'red'
            integer 'blue'
            keyword 'red'
            method 'blue'
            predefined_constant 'cyan'
            symbol 'green'
            regexp {
              self_ 'red'
              char 'magenta'
              content 'red'
              delimiter 'red'
              modifier 'magenta'
              escape 'magenta' }
            shell {
              self_ :bg => 'green'
              char 'magenta'
              content 'yellow'
              delimiter 'white'
              escape 'black' }
            string {
              self_ 'green'
              char 'white'
              content 'green'
              delimiter 'green'
              escape 'white' } } }
      }.should.not.raise
    end
  end

  describe "declaration type guessing" do
    it "guesses random colour types" do
      theme = PryTheme.create(:color_model => 8) {
        define_theme {
          class_ 'magenta'
          class_variable '#1188AA'
          comment 3
          constant 'blue'
          error [111, 111, 101], [31, 125, 255]
          float '0, 0, 125'
          global_variable :bg => 5
          inline_delimiter :bg => '#cabe99'
          string {
            content '#122122', '#FA4499' } } }
      d = theme.definition
      d.class_.foreground.should == 35
      d.class_variable.foreground.should == 30
      d.comment.foreground.should == 33
      d.constant.foreground.should == 34
      d.error.foreground.should == 31
      d.error.background.should == 41
      d.global_variable.foreground.should == false
      d.global_variable.background.should == 45
      d.inline_delimiter.foreground.should == false
      d.inline_delimiter.background.should == 45
      d.string.content.foreground.should == 30
      d.string.content.background.should == 46
    end

    #it "raises error if background and foreground aren't of the same type" do
      #lambda { PryTheme.create(:color_model => 8) {
        #define_theme { class_ 'magenta', '#123456' } } }.
      #should.raise(PryTheme::ThemeError).
      #message.should.match /foreground and background are not of the same type/

      #lambda { PryTheme.create(:color_model => 8) {
        #define_theme { class_ '#123456', 'magenta' } } }.
      #should.raise(PryTheme::ThemeError).
      #message.should.match /foreground and background are not of the same type/

      #lambda { PryTheme.create(:color_model => 8) {
        #define_theme { class_ '#123456', '31, 31, 31' } } }.
      #should.raise(PryTheme::ThemeError).
      #message.should.match /foreground and background are not of the same type/

      #lambda { PryTheme.create(:color_model => 8) {
        #define_theme { class_ '31, 31, 31', '#123456' } } }.
      #should.raise(PryTheme::ThemeError).
      #message.should.match /foreground and background are not of the same type/

      #lambda { PryTheme.create(:color_model => 8) {
        #define_theme { class_ '31, 31, 31', 'magenta' } } }.
      #should.raise(PryTheme::ThemeError).
      #message.should.match /foreground and background are not of the same type/

      #lambda { PryTheme.create(:color_model => 8) {
        #define_theme { class_ 'magenta', '31, 31, 31' } } }.
      #should.raise(PryTheme::ThemeError).
      #message.should.match /foreground and background are not of the same type/
    #end
  end

  describe "state" do
    it "can be active" do
      theme = PryTheme.create{}
      theme.activate
      theme.active?.should == true
    end

    it "can be disabled" do
      theme = PryTheme.create{}
      theme.activate
      theme.disable
      theme.active?.should == false
    end

    it "is inactive by default" do
      theme = PryTheme.create{}
      theme.active?.should == false
    end
  end

  describe "#to_coderay" do
    before do
      @coderay_hash = {
        :class => '48;5;118',
        :class_variable => '0',
        :comment => '0',
        :constant => '0',
        :error => '0',
        :float => '0',
        :global_variable => '38;5;81;4',
        :integer => '38;5;64;48;5;208',
        :inline_delimiter => '0',
        :instance_variable => '0',
        :keyword => '0',
        :method => '0',
        :predefined_constant => '0',
        :symbol => '0',
        :regexp => {
          :self => '0',
          :char => '0',
          :content => '0',
          :delimiter => '0',
          :modifier => '38;5;148',
          :escape => '0',
        },
        :shell => {
          :self => '0',
          :char => '0',
          :content => '0',
          :delimiter => '0',
          :escape => '0',
        },
        :string => {
          :self => '38;5;186',
          :char => '0',
          :content => '0',
          :delimiter => '0',
          :escape => '0',
        }
      }
    end

    it "represents theme definition as a hash" do
      theme = PryTheme.create{
        define_theme{
          class_(:bg => 'viridian')
          integer('olive_drab', 'tangerine')
          global_variable('sky01', [:underline])
          string{ self_('flax') }
          regexp{ modifier('lime01') } } }
      theme.to_coderay.should == @coderay_hash
    end
  end
end
