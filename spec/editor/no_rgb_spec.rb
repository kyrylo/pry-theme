require 'helper'

describe PryTheme::Editor::NoRGB do
  it "converts itself to CSS" do
    norgb = PryTheme::Editor::NoRGB.new
    norgb.to_css.should == 'transparent'
  end
end
