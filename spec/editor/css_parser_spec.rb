require 'helper'

if defined?(PryTheme::Editor)
  describe PryTheme::Editor::CSSParser do

    CSSParser = PryTheme::Editor::CSSParser

    describe "256 colours" do
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

      describe "selector" do
        it "is parsed correctly" do
          ss = @stylesheets.find { |s| s.selector == 'class' }
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

    describe "16 colours" do
      before do
        theme = PryTheme::Theme.new :color_model => 16 do
          define_theme do
            class_ 'bright_red'
            instance_variable 'red'
            constant 'yellow', 'bright_cyan'
            string do
              self_ 'bright_black', 'bright_black'
              delimiter 'bright_white', 'bright_white'
            end
          end
        end
        @stylesheets = CSSParser.parse(theme.definition)
      end

      describe "selector" do
        it "is parsed correctly" do
          ss = @stylesheets.find { |s| s.selector == 'class' }
          ss.color.to_a.should == [255, 0, 0]
          ss.background_color.to_css.should == 'transparent'
        end

        describe "nested" do
          it "is parsed correctly, too" do
            ss = @stylesheets.find { |s| s.selector == 'string' }
            ss.color.to_a.should == [128, 128, 128]
            ss.background_color.to_css.should == 'rgb(0, 0, 0)'

            ss = @stylesheets.find { |s| s.selector == 'string .delimiter' }
            ss.color.to_a.should == [255, 255, 255]
            ss.background_color.to_css.should == 'rgb(192, 192, 192)'
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
    end

    describe "8 colours" do
      before do
        theme = PryTheme::Theme.new :color_model => 8 do
          define_theme do
            class_ 'red'
            instance_variable 'red'
            constant 'yellow', 'cyan'
            string do
              self_ 'black', 'white'
              delimiter 'white', 'white'
            end
          end
        end
        @stylesheets = CSSParser.parse(theme.definition)
      end

      describe "selector" do
        it "is parsed correctly" do
          ss = @stylesheets.find { |s| s.selector == 'class' }
          ss.color.to_a.should == [128, 0, 0]
          ss.background_color.to_css.should == 'transparent'
        end

        describe "nested" do
          it "is parsed correctly, too" do
            ss = @stylesheets.find { |s| s.selector == 'string' }
            ss.color.to_a.should == [0, 0, 0]
            ss.background_color.to_css.should == 'rgb(192, 192, 192)'

            ss = @stylesheets.find { |s| s.selector == 'string .delimiter' }
            ss.color.to_a.should == [192, 192, 192]
            ss.background_color.to_css.should == 'rgb(192, 192, 192)'
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
    end

  end
end
