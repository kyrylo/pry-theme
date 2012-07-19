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
end
