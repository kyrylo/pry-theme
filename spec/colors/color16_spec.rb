require 'helper'

describe PryTheme::Color16 do
  Color16 = PryTheme::Color16

  describe "foreground" do
    it "can be set" do
      color = Color16.new(:foreground => 'bright_red')
      color.foreground(true).should == 'bright_red'
      color.to_ansi.should == "\e[31;1m"

      color = Color16.new(:foreground => 'red')
      color.foreground(true).should == 'red'
      color.to_ansi.should == "\e[31m"
    end

    it "defaults to no colour at all" do
      color = Color16.new
      color.foreground(true).should == false
      color.to_ansi.should == "\e[39;49m"
    end

    it "raises error on invalid value" do
      lambda { Color16.new(:foreground => 'blah') }.
        should.raise(ArgumentError).
        message.should.match /invalid foreground value "blah"/
    end
  end

  describe "background" do
    it "can be set" do
      color = Color16.new(:background => 'blue')
      color.background(true).should == 'blue'
      color.to_ansi.should == "\e[44m"
    end

    it "raises error on invalid value" do
      lambda { Color16.new(:background => 'blah') }.
        should.raise(ArgumentError).
        message.should.match /invalid background value "blah"/
    end
  end

  describe "foreground combined with background" do
    it "can be set" do
      color = Color16.new(
        :foreground => 'bright_yellow',
        :background => 'bright_white')
      color.foreground(true).should == 'bright_yellow'
      color.background(true).should == 'bright_white'
      color.to_ansi.should == "\e[33;1;47m"
    end
  end

  describe "effects" do
    it "can't be bold" do
      lambda { Color16.new(:bold => true).bold? }.should.raise(NoMethodError)
    end

    it "can't be italic" do
      lambda { Color16.new(:italic => true).italic?
        }.should.raise(NoMethodError)
    end

    it "can't be underlined" do
      lambda { Color16.new(:underline => true).underline?
        }.should.raise(NoMethodError)
    end
  end

  describe "argument types" do
    describe "readable" do
      it "works" do
        lambda {
          Color16.new(
            :from => :readable,
            :foreground => 'yellow',
            :background => 'yellow')
        }.should.not.raise
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color16.new(
            :from => :readable,
            :foreground => 'yellow',
            :background => '')
        }.should.raise(ArgumentError)
      end

      it "sets background and foreground properly" do
        color = Color16.new(:from => :readable,
                            :foreground => 'bright_black',
                            :background => 'green')
        color.foreground.should == '30;1'
        color.foreground(true).should == 'bright_black'
        color.background.should == 42
        color.background(true).should == 'green'
      end

      it "sets foreground properly" do
        color = Color16.new(:from => :readable, :foreground => 'bright_black')
        color.foreground.should == '30;1'
        color.foreground(true).should == 'bright_black'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color16.new(:from => :readable, :background => 'green')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 42
        color.background(true).should == 'green'
      end
    end

    describe "hex" do
      it "works" do
        lambda {
          Color16.new(
            :from => :hex,
            :foreground => '#afaf11',
            :background => '#eaeaea')
        }.should.not.raise
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color16.new(
            :from => :hex,
            :foreground => '#222222',
            :background => [123, 11, 44])
        }.should.raise(TypeError)
      end

      it "sets background and foreground properly" do
        color = Color16.new(:from => :hex,
                            :foreground => '#afaf11',
                            :background => '#eaeaea')
        color.foreground.should == '30;1'
        color.foreground(true).should == 'bright_black'
        color.background.should == 43
        color.background(true).should == 'bright_yellow'
      end

      it "sets foreground properly" do
        color = Color16.new(:from => :hex, :foreground => '#afaf11')
        color.foreground.should == '30;1'
        color.foreground(true).should == 'bright_black'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color16.new(:from => :hex, :background => '#eaeaea')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 43
        color.background(true).should == 'bright_yellow'
      end
    end

    describe "rgb" do
      it "works" do
        lambda {
          Color16.new(
            :from => :rgb,
            :foreground => '31, 125, 88',
            :background => [123, 11, 44])
        }.should.not.raise(ArgumentError)
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color16.new(
            :from => :rgb,
            :foreground => '#222222',
            :background => [123, 11, 44])
        }.should.raise(ArgumentError)
      end

      it "sets background and foreground properly" do
        color = Color16.new(:from => :rgb,
                            :foreground => '31, 31, 101',
                            :background => '125, 101, 255')
        color.foreground.should == 31
        color.foreground(true).should == 'red'
        color.background.should == 46
        color.background(true).should == 'cyan'
      end

      it "sets foreground properly" do
        color = Color16.new(:from => :rgb, :foreground => '31, 31, 101')
        color.foreground.should == 31
        color.foreground(true).should == 'red'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color16.new(:from => :rgb, :background => '125, 101, 255')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 46
        color.background(true).should == 'cyan'
      end
    end

    describe "term" do
      it "works" do
        lambda {
          Color16.new(
            :from => :term,
            :foreground => 10,
            :background => 7)
        }.should.not.raise(ArgumentError)
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color16.new(
            :from => :term,
            :foreground => 10,
            :background => 'asd')
        }.should.raise(TypeError)
      end

      it "sets background and foreground properly" do
        color = Color16.new(:from => :term, :foreground => 4, :background => 8)
        color.foreground.should == 34
        color.foreground(true).should == 'blue'
        color.background.should == 40
        color.background(true).should == 'bright_black'
      end

      it "sets foreground properly" do
        color = Color16.new(:from => :term, :foreground => 4)
        color.foreground.should == 34
        color.foreground(true).should == 'blue'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color16.new(:from => :term, :background => 8)
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 40
        color.background(true).should == 'bright_black'
      end
    end
  end

end
