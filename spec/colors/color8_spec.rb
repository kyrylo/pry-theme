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
    end
  end
end
