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

    describe "effects" do
      it "not used if there is a custom foreground" do
        color = Color8.new(:foreground => 'cyan')
        color.bold?.should == false
        color.underline?.should == false
        color.italic?.should == false
        color.to_ansi.should == '36'
      end

      it "uses bold" do
        color = Color8.new(:foreground => 'magenta', :bold => true)
        color.bold?.should == true
        color.underline?.should == false
        color.italic?.should == false
        color.to_ansi.should == '35;1'
      end

      it "uses underline" do
        color = Color8.new(:foreground => 'yellow', :underline => true)
        color.bold?.should == false
        color.underline?.should == true
        color.italic?.should == false
        color.to_ansi.should == '33;4'
      end

      it "uses italic" do
        color = Color8.new(:foreground => 'black', :italic => true)
        color.bold?.should == false
        color.underline?.should == false
        color.italic?.should == true
        color.to_ansi.should == '30;3'
      end

      it "combines everything" do
        color = Color8.new(
          :foreground => 'green',
            :italic    => true,
            :bold      => true,
            :underline => true)
        color.bold?.should == true
        color.underline?.should == true
        color.italic?.should == true
        color.to_ansi.should == '32;1;3;4'
      end

      describe "with defaults" do
        it "not used for the default colours" do
          color = Color8.new
          color.bold?.should == false
          color.underline?.should == false
          color.italic?.should == false
          color.to_ansi.should == '39;49'
        end

        it "can be used without foreground" do
          color = Color8.new(:background => 'red', :bold => true)
          color.bold?.should == true
          color.underline?.should == false
          color.italic?.should == false
          color.to_ansi.should == '41;1'
        end

        it "can be used with the default colour" do
          color = Color8.new(:bold => true, :italic => true, :underline => true)
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
      color = Color8.new(
        :background => 'red',
        :foreground => 'green')
      color.foreground(true).should == 'green'
      color.background(true).should == 'red'
      color.to_ansi.should == '32;41'
    end

    it "can be set with effects" do
      color = Color8.new(
        :background => 'red',
        :foreground => 'green',
          :italic    => true,
          :bold      => true,
          :underline => true)
      color.to_ansi.should == '32;1;3;4;41'
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
