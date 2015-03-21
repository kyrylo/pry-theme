t = PryTheme.create :name => 'pry-cold' do
  author :name => 'John Mair'
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Based on Charcoalblack theme from Emacs'

  define_theme do
    class_ 'robin_egg_blue02', [:bold]
    class_variable 'pale_blue03', [:bold]
    comment 'light_grey03'
    constant 'robin_egg_blue02', [:bold]
    error 'robin_egg_blue02', [:bold, :italic]
    float 'silver01'
    global_variable 'robin_egg_blue02'
    inline_delimiter 'puce01'
    instance_variable 'pale_blue03'
    integer 'seroburomalinovyj01'
    keyword 'pale_blue03', [:bold]
    method 'royal_blue05'
    predefined_constant 'robin_egg_blue02', [:bold]
    symbol 'bluish03'

    regexp do
      self_ 'gray02'
      char 'white'
      content 'bluish03'
      delimiter 'gray02'
      modifier 'gray02'
      escape 'puce01'
    end

    shell do
      self_ 'gray02'
      char 'white'
      content 'puce01'
      delimiter 'gray02'
      escape 'puce01'
    end

    string do
      self_ 'bluish03'
      char 'white'
      content 'bluish03'
      delimiter 'bluish03'
      escape 'puce01'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
