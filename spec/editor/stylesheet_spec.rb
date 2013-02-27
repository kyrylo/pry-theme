require 'helper'

describe PryTheme::Editor::Stylesheet do

  it "has selector" do
    stylesheet = PryTheme::Editor::Stylesheet.new('piglet')
    stylesheet.selector.should == 'piglet'
  end

  it "defaults to some values" do
    stylesheet = PryTheme::Editor::Stylesheet.new('piglet')
    stylesheet.css.should =~ /color: rgb\(0, 0, 0\)/
    stylesheet.css.should =~ /background-color: transparent/
    stylesheet.css.should =~ /font-style: normal/
    stylesheet.css.should =~ /font-weight: normal/
    stylesheet.css.should =~ /text-decoration: none/
  end

  it "defines attributes" do
    stylesheet = PryTheme::Editor::Stylesheet.new('winnie .the .pooh') do |s|
      s.color = PryTheme::RGB.new([213, 211, 44])
      s.background_color = PryTheme::RGB.new([21, 0, 11])
      s.font_style = 'italic'
      s.font_weight = 'bold'
      s.text_decoration = 'underline'
    end

    stylesheet.css.should =~ /winnie .the .pooh/
    stylesheet.css.should =~ /color: rgb\(213, 211, 44\)/
    stylesheet.css.should =~ /background-color: rgb\(21, 0, 11\)/
    stylesheet.css.should =~ /font-style: italic/
    stylesheet.css.should =~ /font-weight: bold/
    stylesheet.css.should =~ /text-decoration: underline/
  end

end
