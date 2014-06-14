require 'helper'

describe PryTheme::ColorTable do
  describe "::build_color_string" do
    before do
      @color256 = PryTheme::Color256.new(:foreground => 100, :background => 101)
      @color16 = PryTheme::Color16.new(:foreground => 9, :background => 10)
      @color8 =  PryTheme::Color8.new(:foreground => 3, :background => 4)
    end

    it "builds a suitable (visually) for colour table (256) row" do
      output = PryTheme::ColorTable.build_color_string(@color256)
      output.should ==
        "\e[7;38;5;100;48;5;101m100\e[0m:\e[38;5;100;48;5;101molive01\e[0m"
    end

    it "builds a suitable (visually) for colour table (16) row" do
      output = PryTheme::ColorTable.build_color_string(@color16)
      output.should == "\e[7;31;1;42m31;1\e[0m:\e[31;1;42mbright_red\e[0m"
    end

    it "builds a suitable (visually) for colour table (8) row" do
      output = PryTheme::ColorTable.build_color_string(@color8)
      output.should == "\e[7;33;44m33\e[0m:\e[33;44myellow\e[0m"
    end
  end

  describe "#table" do
    it "returns proper table for with 256 colours" do
      table = PryTheme::ColorTable.t256
      table.should =~ /Color model 256/
      table.should =~ /\e\[7;38;5;147m147\e\[0m:\e\[38;5;147mwisteria02\e\[0m/
      table.should =~ /\e\[7;38;5;24m24\e\[0m:\e\[38;5;24mcerulean_grey01\e\[0m/
      table.should =~ /\e\[7;38;5;0m0\e\[0m:\e\[38;5;0mblack\e\[0m/
    end

    it "returns proper table for with 16 colours" do
      table = PryTheme::ColorTable.t16
      table.should =~ /Color model 16/
      table.should =~ /\n  \e\[7;30m0\e\[0m:\e\[30mblack\e\[0m/
      table.should =~ /\e\[7;35;1m13\e\[0m:\e\[35;1mbright_magenta\e\[0m/
      table.should =~ /\e\[7;37;1m15\e\[0m:\e\[37;1mbright_white\e\[0m\n/
    end

    it "returns proper table for with 8 colours" do
      table = PryTheme::ColorTable.t8
      table.should =~ /Color model 8/
      table.should =~ /: \e\[7;30m0\e\[0m:\e\[30mblack\e\[0m/
      table.should =~ /\e\[7;33m3\e\[0m:\e\[33myellow\e\[0m/
      table.should =~ /\e\[7;37m7\e\[0m:\e\[37mwhite\e\[0m\n/
    end
  end
end
