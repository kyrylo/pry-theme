require 'helper'

describe PryTheme::Color8 do
  Color8 = PryTheme::Color8

  describe "foreground" do
    it "can be set" do
      color = Color8.new(:foreground => 'red')
      color.foreground(true).should == 'red'
      color.to_ansi.should == '31'
    end

    it "defaults to no colour at all" do
      color = Color8.new
      color.foreground(true).should == false
      color.to_ansi.should == '39;49'
    end

    it "raises error on invalid value" do
      lambda { Color8.new(:foreground => 'blah') }.
        should.raise(ArgumentError).
        message.should.match /invalid foreground value "blah"/
    end
  end

  describe "background" do
    it "can be set" do
      color = Color8.new(:background => 'blue')
      color.background(true).should == 'blue'
      color.to_ansi.should == '44'
    end

    it "defaults to no colour at all" do
      color = Color8.new
      color.background(true).should == false
      color.to_ansi.should == '39;49'
    end

    it "raises error on invalid value" do
      lambda { Color8.new(:background => 'BLACK') }.
        should.raise(ArgumentError).
        message.should.match /invalid background value "BLACK"/
    end
  end

  describe "foreground combined with background" do
    it "can be set" do
      color = Color8.new(:foreground => 'green', :background => 'red')
      color.foreground(true).should == 'green'
      color.background(true).should == 'red'
      color.to_ansi.should == '32;41'
    end
  end

  describe "argument types" do
    describe "readable" do
      it "works" do
        lambda {
          Color8.new(
            :from => :readable,
            :foreground => 'black',
            :background => 'white')
        }.should.not.raise
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color8.new(
            :from => :readable,
            :foreground => '#222222',
            :background => [123, 11, 44])
        }.should.raise(ArgumentError)
      end

      it "sets background and foreground properly" do
        color = Color8.new(:from => :readable,
                            :foreground => 'black',
                            :background => 'green')
        color.foreground.should == 30
        color.foreground(true).should == 'black'
        color.background.should == 42
        color.background(true).should == 'green'
      end

      it "sets foreground properly" do
        color = Color8.new(:from => :readable, :foreground => 'black')
        color.foreground.should == 30
        color.foreground(true).should == 'black'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color8.new(:from => :readable, :background => 'green')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 42
        color.background(true).should == 'green'
      end
    end

    describe "hex" do
      it "works" do
        lambda {
          Color8.new(
            :from => :hex,
            :foreground => '#afaf11',
            :background => '#eaeaea')
        }.should.not.raise
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color8.new(
            :from => :hex,
            :foreground => '#222222',
            :background => [123, 11, 44])
        }.should.raise(TypeError)
      end

      it "sets background and foreground properly" do
        color = Color8.new(:from => :hex,
                            :foreground => '#afaf11',
                            :background => '#eaeaea')
        color.foreground.should == 34
        color.foreground(true).should == 'blue'
        color.background.should == 45
        color.background(true).should == 'magenta'
      end

      it "sets foreground properly" do
        color = Color8.new(:from => :hex, :foreground => '#afaf11')
        color.foreground.should == 34
        color.foreground(true).should == 'blue'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color8.new(:from => :hex, :background => '#eaeaea')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 45
        color.background(true).should == 'magenta'
      end
    end

    describe "rgb" do
      it "works" do
        lambda {
          Color8.new(
            :from => :rgb,
            :foreground => '31, 125, 88',
            :background => [123, 11, 44])
        }.should.not.raise(ArgumentError)
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color8.new(
            :from => :rgb,
            :foreground => '#222222',
            :background => [123, 11, 44])
        }.should.raise(ArgumentError)
      end

      it "sets background and foreground properly" do
        color = Color8.new(:from => :rgb,
                            :foreground => '31, 31, 101',
                            :background => '125, 101, 255')
        color.foreground.should == 30
        color.foreground(true).should == 'black'
        color.background.should == 43
        color.background(true).should == 'yellow'
      end

      it "sets foreground properly" do
        color = Color8.new(:from => :rgb, :foreground => '31, 31, 101')
        color.foreground.should == 30
        color.foreground(true).should == 'black'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color8.new(:from => :rgb, :background => '125, 101, 255')
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 43
        color.background(true).should == 'yellow'
      end
    end

    describe "term" do
      it "works" do
        lambda {
          Color8.new(
            :from => :term,
            :foreground => 1,
            :background => 7)
        }.should.not.raise(ArgumentError)
      end

      it "doesn't work with incorrect input" do
        lambda {
          Color8.new(
            :from => :term,
            :foreground => 33,
            :background => 42)
        }.should.raise(ArgumentError)
      end

      it "sets background and foreground properly" do
        color = Color8.new(:from => :term, :foreground => 0, :background => 7)
        color.foreground.should == 30
        color.foreground(true).should == 'black'
        color.background.should == 47
        color.background(true).should == 'white'
      end

      it "sets foreground properly" do
        color = Color8.new(:from => :term, :foreground => 0)
        color.foreground.should == 30
        color.foreground(true).should == 'black'
        color.background.should == false
        color.background(true).should == false
      end

      it "sets background properly" do
        color = Color8.new(:from => :term, :background => 7)
        color.foreground.should == false
        color.foreground(true).should == false
        color.background.should == 47
        color.background(true).should == 'white'
      end
    end
  end
end
