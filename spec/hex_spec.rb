require 'helper'

describe PryTheme::HEX do
  HEX = PryTheme::HEX

  it "accepts String with an octothorp as an argument" do
    lambda { HEX.new('#ffffff') }.should.not.raise
    lambda { HEX.new('#FFFFFF') }.should.not.raise
  end

  it "doesn't accept malformed arguments" do
    lambda { HEX.new('#fffffff') }.should.raise ArgumentError
    lambda { HEX.new('ffffff') }.should.raise ArgumentError
    lambda { HEX.new('dqwdqw') }.should.raise ArgumentError
    lambda { HEX.new(:boom) }.should.raise TypeError
  end

  it "converts itself to rgb" do
    HEX.new('#ffffff').to_rgb.to_a.should == [255, 255, 255]
  end

  it "converts itself to term 256" do
    HEX.new('#ffffff').to_term.to_i.should == 15
    HEX.new('#ffffff').to_term(256).to_i.should == 15
  end

  it "converts itself to term 256 and determines the nearest term colour" do
    HEX.new('#fefefe').to_term.to_i.should == 15
    HEX.new('#cecece').to_term.to_i.should == 189
  end

  it "converts itself to term 16" do
    HEX.new('#ffffff').to_term(16).to_i.should == 15
  end

  it "converts itself to term 16 and determines the nearest term colour" do
    HEX.new('#fefefe').to_term(16).to_i.should == 15
    HEX.new('#cecece').to_term(16).to_i.should == 11
  end

  it "represents itself as String" do
    HEX.new('#ffffff').to_s.should == '#ffffff'
  end
end
