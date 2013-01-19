require 'helper'

describe PryTheme::Color16 do
  Color16 = PryTheme::Color16

  describe "foreground" do
    it "can be set" do
      color = Color16.new(:foreground => 'bright_red')
      color.foreground(true).should == 'bright_red'
      color.to_ansi.should == '31;1'

      color = Color16.new(:foreground => 'red')
      color.foreground(true).should == 'red'
      color.to_ansi.should == '31'
    end

    it "defaults to no colour at all" do
      color = Color16.new
      color.foreground(true).should == false
      color.to_ansi.should == '39;49'
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
      color.to_ansi.should == '44'
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
      color.to_ansi.should == '33;1;47'
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
        binding.pry
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
    end
  end

end
