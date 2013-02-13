require 'helper'

describe PryTheme::Editor::CSSParser do

  CSSParser = PryTheme::Editor::CSSParser

  before do
    theme = PryTheme::Theme.new do
      define_theme do
        class_ 23, [:underline]
        instance_variable 23, [:italic]
        constant 23, 23, [:bold]
        string do
          self_ 23, 23
          delimiter 23
        end
      end
    end
    @stylesheets = CSSParser.parse(theme.definition)
  end

  describe "selectors" do
    it "is parsed correctly" do
      ss = @stylesheets.find { |s| s.selector == 'class'}
      ss.color.to_a.should == [0, 95, 95]
      ss.background_color.to_css.should == 'transparent'
    end

    describe "nested" do
      it "is parsed correctly, too" do
        ss = @stylesheets.find { |s| s.selector == 'string' }
        ss.color.to_a.should == [0, 95, 95]
        ss.background_color.to_css.should == 'rgb(0, 95, 95)'

        ss = @stylesheets.find { |s| s.selector == 'string .delimiter' }
        ss.color.to_a.should == [0, 95, 95]
        ss.background_color.to_css.should == 'transparent'
      end
    end

    describe "default" do
      it "is parsed correctly as well" do
        ss = @stylesheets.find { |s| s.selector == 'symbol' }
        ss.color.to_a.should == [0, 0, 0]
        ss.background_color.to_css.should == 'transparent'
      end
    end
  end

  describe "effects" do
    it "parses italic" do
      ss = @stylesheets.find { |s| s.selector == 'instance-variable' }
      ss.font_style.should == 'italic'
    end

    it "parses bold" do
      ss = @stylesheets.find { |s| s.selector == 'constant' }
      ss.font_weight.should == 'bold'
    end

    it "parses underline" do
      ss = @stylesheets.find { |s| s.selector == 'class' }
      ss.text_decoration.should == 'underline'
    end
  end

end
