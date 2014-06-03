require 'helper'

describe PryTheme::Config do
  before do
    @token_colors = CodeRay::Encoders::Terminal::TOKEN_COLORS
    @old_key_token = @token_colors[:key]
    @token_colors[:key].should != @token_colors[:symbol]
  end

  after do
    CodeRay::Encoders::Terminal::TOKEN_COLORS[:key] = @old_key_token
  end

  describe "#apply" do
    describe ":paint_key_as_symbol is true" do
      before do
        PryTheme::Config.new(paint_key_as_symbol: true).apply
      end

      it "sets the key token to the value of the symbol token" do
        @token_colors[:key].should == @token_colors[:symbol]
      end
    end

    describe ":paint_key_as symbol is false" do
      before do
        PryTheme::Config.new(paint_key_as_symbol: false).apply
      end

      it "doesn't set the key token to the value of the symbol token" do
        @token_colors[:key].should != @token_colors[:symbol]
      end
    end
  end
end
