require 'helper'

describe PryTheme::Editor::RandomNameable do

  describe "#generate_random_name" do
    before do
      class Person
        include PryTheme::Editor::RandomNameable
        attr_reader :name
        def initialize; @name = generate_random_name; end
      end
    end

    after do
      Object.instance_eval { remove_const :Person }
    end

    it "provides random name" do
      first = Person.new.name
      second = Person.new.name
      first.should != second
    end
  end

end
