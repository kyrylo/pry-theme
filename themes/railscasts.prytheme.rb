t = PryTheme.create :name => 'railscasts' do
  author :name => 'Ryan Fitzgerald'
  author :name => 'John Mair'
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'The famous RailsCasts theme'

  define_theme do
    class_ 'white'
    class_variable 'robin_egg_blue03'
    comment 'tan'
    constant 'white'
    error 'white', 'maroon'
    float 'asparagus'
    global_variable :bg => 'robin_egg_blue03'
    inline_delimiter 'emerald02'
    instance_variable 'robin_egg_blue03'
    integer 'asparagus'
    keyword 'international_orange'
    method 'mustard02'
    predefined_constant 'robin_egg_blue03'
    symbol 'cornflower_blue01'

    regexp do
      self_ 'asparagus'
      char 'orange'
      content 'asparagus'
      delimiter 'asparagus'
      modifier 'asparagus'
      escape 'emerald02'
    end

    shell do
      self_ 'asparagus'
      char 'orange'
      content 'asparagus'
      delimiter 'asparagus'
      escape 'emerald02'
    end

    string do
      self_ 'asparagus'
      char 'orange'
      content 'asparagus'
      delimiter 'asparagus'
      escape 'emerald02'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
