require 'helper'

describe PryTheme::RGB do
  RGB = PryTheme::RGB

  it "accepts Array as an argument" do
    lambda { RGB.new([0, 0, 0]) }.should.not.raise
  end

  it "doesn't accept malformed Arrays" do
    lambda { RGB.new([0, 0, 0, 0]) }.should.raise ArgumentError
    lambda { RGB.new([256, 256, 256]) }.should.raise ArgumentError
    lambda { RGB.new([:one, 256, 256]) }.should.raise ArgumentError
  end

  it "accepts String as an argument" do
    lambda { RGB.new('0, 0, 0') }.should.not.raise
  end

  it "doesn't accept malformed Strings" do
    lambda { RGB.new('0, 0, 0, 0') }.should.raise ArgumentError
    lambda { RGB.new('256, 256, 256') }.should.raise ArgumentError
    lambda { RGB.new('256, heaven, 256') }.should.raise ArgumentError
  end

  it "raises error if gibberish is given as an argument" do
    lambda { RGB.new('jeyenne') }.should.raise ArgumentError
    lambda { RGB.new(:jeyenne) }.should.raise TypeError
  end

  it "converts itself to term 256" do
    RGB.new([0, 0, 0]).to_term.to_i.should == 0
    RGB.new('255, 255, 255').to_term.to_i.should == 15
  end

  it "converts itself to term 256 and determines the nearest term colour" do
    RGB.new('21, 24, 205').to_term.to_i.should == 20
    RGB.new('210, 240, 20').to_term.to_i.should == 191
  end

  it "converts itself to term 16" do
    RGB.new([0, 0, 0]).to_term(16).to_i.should == 0
    RGB.new([255, 255, 255]).to_term(16).to_i.should == 15
    RGB.new([255, 0, 255]).to_term(16).to_i.should == 13
  end

  it "converts itself to and determines the nearest term colour" do
    RGB.new([0, 101, 69]).to_term(16).to_i.should == 1
  end

  it "converts itself to term 8" do
    RGB.new([0, 0, 0]).to_term(8).to_i.should == 0
    RGB.new([255, 255, 255]).to_term(8).to_i.should == 0
    RGB.new([255, 0, 255]).to_term(8).to_i.should == 0
  end

  it "converts itself to and determines the nearest term colour" do
    RGB.new([0, 101, 69]).to_term(16).to_i.should == 1
    RGB.new([122, 122, 122]).to_term(8).to_i.should == 3
    RGB.new([176, 127, 30]).to_term(8).to_i.should == 4
  end

  it "converts itself to hex" do
    RGB.new([0, 0, 0]).to_hex.to_s.should == '#000000'
    RGB.new([255, 255, 255]).to_hex.to_s.should == '#ffffff'
  end

  it "represents itself as a String" do
    RGB.new([0, 0, 0]).to_s.should == '0, 0, 0'
    RGB.new('0, 0, 0').to_s.should == '0, 0, 0'
  end

  it "represents itself as an Array" do
    RGB.new([0, 0, 0]).to_a.should == [0, 0, 0]
    RGB.new('0, 0, 0').to_a.should == [0, 0, 0]
  end
end
