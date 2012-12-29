require 'helper'

describe PryTheme::TERM do
  TERM = PryTheme::TERM

  it "represents itself as Fixnum" do
    TERM.new(23).to_i.should == 23
  end

  it "has color model parameter" do
    TERM.new(1).color_model.should == 256
    TERM.new(1, 16).color_model.should == 16
  end

  it "doesn't accept malformed arguments" do
    lambda { TERM.new(-23) }.should.raise ArgumentError
    lambda { TERM.new(256) }.should.raise ArgumentError
    lambda { TERM.new(25, 16) }.should.raise ArgumentError
    lambda { TERM.new(25, '16') }.should.raise TypeError
    lambda { TERM.new(:one) }.should.raise TypeError
    lambda { TERM.new('25') }.should.raise TypeError
  end
end
