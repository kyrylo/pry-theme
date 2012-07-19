require 'helper'

describe "PryTheme::Commands" do
  describe "color option" do
    it "should display a color when given a numeric argument" do
      mock_pry(binding, "pry-theme -c 23").should =~ /dark_turquoise/
    end

    it "should display warning when invalid color number given" do
      out = mock_pry("pry-theme -c 1000")
      out.should =~ /Invalid color: 1000/
    end

    it "should display warning when random symbols given" do
      out = mock_pry("pry-theme -c $_dopey+")
      out.should =~ /Invalid color: \$_dopey\+/
    end

    it "should display a color when a hex given" do
      mock_pry("pry-theme -c #625a2d").should =~ /khaki01/
    end

    it "should display a color when an rgb given" do
      mock_pry("pry-theme -c 95,196,60").should =~ /pale_green01/
    end

    it "should display a color when a human-readable name given" do
      mock_pry("pry-theme -c steel_blue").should =~ /steel_blue/
    end

    it "should display multiple colors when a substring given" do
      out = mock_pry("pry-theme -c dark_t")

      out.should =~ /dark_turquoise/
      out.should =~ /dark_tan/
      out.should =~ /dark_tea_green/
    end
  end

  describe "all-colors option" do
    it "should display all colors for 8-color palette" do
      out = mock_pry("pry-theme -a 8")

      out.should =~ /black/
      out.should =~ /magenta/
    end

    #it "should display all colors for 256-color palette" do
      #out = mock_pry("pry-theme -a 256")

      #out.should =~ /black/
      #out.should =~ /seashell/
    #end
  end
end
