require 'helper'

describe PryTheme::Helper do
  before do
    @h = PryTheme::Helper
  end

  it "should show correctly default themes" do
    themes = %w{
      zenburn solarized vim-default railscasts pry-cold saturday twilight
      github monokai pry-modern tomorrow pry-classic vim-detailed
    }
    themes.map! { |theme| theme + ".prytheme" }

    (@h.example_themes - themes).should == []
  end

  it "should show correct theme file_version" do
    path = File.join(File.dirname(__FILE__), "fixtures", "pry-classic.prytheme")
    @h.theme_file_version(path).should == 4
  end

  it "should detect ansi color" do
    @h.ansi?(0).should == true
    @h.ansi?(-1).should == false
    @h.ansi?(256).should == false
    @h.ansi?("bashful").should == false
  end

  it "should detect rgb color" do
    @h.rgb?("55,55,55").should == true
    @h.rgb?("0,0,0").should == true
    @h.rgb?("256,255,255").should == false
    @h.rgb?("1").should == false
    @h.rgb?("55,55,55,").should == false
    @h.rgb?("sneezy").should == false
  end

  it "should detect hex color" do
    @h.hex?("#373737").should == true
    @h.hex?("3A3F3E").should == true
    @h.hex?("dopey").should == false
    @h.hex?(373737).should == false
  end
end
