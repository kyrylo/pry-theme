require 'helper'

describe PryTheme::Color256 do
  Color256 = PryTheme::Color256

  describe "foreground" do
    it "can be set" do
      color = Color256.new(:foreground => 'bright_violet')
      color.foreground(true).should == 'bright_violet'
      color.to_ansi.should == '38;5;164'
    end

    it "defaults to no colour at all" do
      color = Color256.new
      color.foreground(true).should == false
      color.to_ansi.should == '0'
    end

    it "raises error on invalid value" do
      lambda { Color256.new(:foreground => 'blah') }.
        should.raise(ArgumentError).
        message.should.match /invalid foreground value "blah"/
    end

    describe "effects" do
      it "not used if there is a custom foreground" do
        color = Color256.new(:foreground => 'bright_violet')
        color.bold?.should == false
        color.underline?.should == false
        color.italic?.should == false
        color.to_ansi.should == '38;5;164'
      end

      it "uses bold" do
        color = Color256.new(:foreground => 'dark_pear', :bold => true)
        color.bold?.should == true
        color.underline?.should == false
        color.italic?.should == false
        color.to_ansi.should == '38;5;178;1'
      end

      it "uses underline" do
        color = Color256.new(:foreground => 'royal_blue03', :underline => true)
        color.bold?.should == false
        color.underline?.should == true
        color.italic?.should == false
        color.to_ansi.should == '38;5;62;4'
      end

      it "uses italic" do
        color = Color256.new(:foreground => 'cerise01', :italic => true)
        color.bold?.should == false
        color.underline?.should == false
        color.italic?.should == true
        color.to_ansi.should == '38;5;161;3'
      end

      it "combines everything" do
        color = Color256.new(
          :foreground => 'titian',
            :italic    => true,
            :bold      => true,
            :underline => true)
        color.bold?.should == true
        color.underline?.should == true
        color.italic?.should == true
        color.to_ansi.should == '38;5;160;1;3;4'
      end

      describe "with defaults" do
        it "not used for the default colours" do
          color = Color256.new
          color.bold?.should == false
          color.underline?.should == false
          color.italic?.should == false
          color.to_ansi.should == '0'
        end

        it "can be used without foreground" do
          color = Color256.new(:background => 'bistre', :bold => true)
          color.bold?.should == true
          color.underline?.should == false
          color.italic?.should == false
          color.to_ansi.should == '48;5;235;1'
        end

        it "can be used with the default colour" do
          color = Color256.new(:bold => true, :italic => true, :underline => true)
          color.bold?.should == true
          color.underline?.should == true
          color.italic?.should == true
          color.to_ansi.should == '1;3;4'
        end
      end
    end
  end

  describe "background" do
    it "can be set" do
      color = Color256.new(:background => 'bright_violet')
      color.background(true).should == 'bright_violet'
      color.to_ansi.should == '48;5;164'
    end

    it "defaults to no colour at all" do
      color = Color256.new
      color.background(true).should == false
      color.to_ansi.should == '0'
    end

    it "raises error on invalid value" do
      lambda { Color256.new(:background => 'BLACK') }.
        should.raise(ArgumentError).
        message.should.match /invalid background value "BLACK"/
    end
  end

  describe "foreground combined with background" do
    it "can be set" do
      color = Color256.new(
        :background => 'red_violet01',
        :foreground => 'pale_brown')
      color.foreground(true).should == 'pale_brown'
      color.background(true).should == 'red_violet01'
      color.to_ansi.should == '38;5;137;48;5;126'
    end

    it "can be set with effects" do
      color = Color256.new(
        :background => 'red_violet01',
        :foreground => 'pale_brown',
          :italic    => true,
          :bold      => true,
          :underline => true)
      color.to_ansi.should == '38;5;137;1;3;4;48;5;126'
    end
  end

  describe "argument types" do
    describe "readable" do
      it "works" do
        lambda {
          Color256.new(
            :from => :readable,
            :foreground => 'tan',
            :background => 'gold')
        }.should.not.raise
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color256.new(
            :from => :readable,
            :foreground => '#222222',
            :background => [123, 11, 44])
        }.should.raise(ArgumentError)
      end

      it "sets background and foreground properly" do
        color = Color256.new(:from => :readable,
                             :foreground => 'dark_indigo',
                             :background => 'klein_blue')
        color.foreground.should == 17
        color.foreground(true).should == 'dark_indigo'
        color.background.should == 32
        color.background(true).should == 'klein_blue'
      end

      it "sets foreground properly" do
        color = Color256.new(:from => :readable, :foreground => 'dark_indigo')
        color.foreground.should == 17
        color.foreground(true).should == 'dark_indigo'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color256.new(:from => :readable, :background => 'klein_blue')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 32
        color.background(true).should == 'klein_blue'
      end
    end

    describe "hex" do
      it "works" do
        lambda {
          Color256.new(
            :from => :hex,
            :foreground => '#afaf11',
            :background => '#eaeaea')
        }.should.not.raise
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color256.new(
            :from => :hex,
            :foreground => '#222222',
            :background => [123, 11, 44])
        }.should.raise(TypeError)
      end

      it "sets background and foreground properly" do
        color = Color256.new(:from => :hex,
                            :foreground => '#afaf11',
                            :background => '#eaeaea')
        color.foreground.should == 142
        color.foreground(true).should == 'old_gold'
        color.background.should == 189
        color.background(true).should == 'periwinkle'
      end

      it "sets foreground properly" do
        color = Color256.new(:from => :hex, :foreground => '#afaf11')
        color.foreground.should == 142
        color.foreground(true).should == 'old_gold'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color256.new(:from => :hex, :background => '#eaeaea')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 189
        color.background(true).should == 'periwinkle'
      end
    end

    describe "rgb" do
      it "works" do
        lambda {
          Color256.new(
            :from => :rgb,
            :foreground => '31, 125, 88',
            :background => [123, 11, 44])
        }.should.not.raise(ArgumentError)
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color256.new(
            :from => :rgb,
            :foreground => '#222222',
            :background => [123, 11, 44])
        }.should.raise(ArgumentError)
      end

      it "sets background and foreground properly" do
        color = Color256.new(:from => :rgb,
                            :foreground => '31, 31, 101',
                            :background => '125, 101, 255')
        color.foreground.should == 17
        color.foreground(true).should == 'dark_indigo'
        color.background.should == 99
        color.background(true).should == 'heliotrope01'
      end

      it "sets foreground properly" do
        color = Color256.new(:from => :rgb, :foreground => '31, 31, 101')
        color.foreground.should == 17
        color.foreground(true).should == 'dark_indigo'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color256.new(:from => :rgb, :background => '125, 101, 255')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 99
        color.background(true).should == 'heliotrope01'
      end
    end

    describe "term" do
      it "works" do
        lambda {
          Color256.new(
            :from => :term,
            :foreground => 31,
            :background => 123)
        }.should.not.raise(ArgumentError)
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color256.new(
            :from => :term,
            :foreground => '#222222',
            :background => 'gray05')
        }.should.raise(TypeError)
      end

      it "sets background and foreground properly" do
        color = Color256.new(:from => :term, :foreground => 4, :background => 84)
        color.foreground.should == 4
        color.foreground(true).should == 'navy_blue'
        color.background.should == 84
        color.background(true).should == 'spring_green03'
      end

      it "sets foreground properly" do
        color = Color256.new(:from => :term, :foreground => 4)
        color.foreground.should == 4
        color.foreground(true).should == 'navy_blue'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color256.new(:from => :term, :background => 84)
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 84
        color.background(true).should == 'spring_green03'
      end
    end
  end

end
