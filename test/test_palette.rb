require 'helper'

describe "A PryTheme::Color instance" do
  before do
    @c = PryTheme::Color.new("111", "dopey")
  end

  it "should represent itself in terminal form" do
    @c.to_term("38;5;").should == "\e[38;5;111;7m111\e[0m:\e[38;5;111mdopey\e[0m"
  end
end
