require 'helper'

describe PryTheme::ColorConverter do

  before do
    @converter = PryTheme::ColorConverter
  end

  describe PryTheme::ColorConverter::COLORS do
    it 'should have 256 colors' do
      @converter::COLORS.size.should == 256
    end
  end

  it "should convert from rgb to hex" do
    @converter.rgb_to_hex("55,55,55").should == "#373737"
  end

  it "should convert from rgb to ansi" do
    @converter.rgb_to_ansi("55,55,55").should == 59
  end

  it "should convert from hex to rgb with an octothorp sign" do
    @converter.hex_to_rgb("#373737").should == [55, 55, 55]
  end

  it "should convert from hex to rgb without an octothorp sign" do
    @converter.hex_to_rgb("373737").should == [55, 55, 55]
  end

  it "should convert from hex to ansi with an octothorp sign" do
    @converter.hex_to_ansi("#373737").should == 59
  end

  it "should convert from ansi to rgb without an octothorp sign" do
    @converter.hex_to_ansi("373737").should == 59
  end
end
