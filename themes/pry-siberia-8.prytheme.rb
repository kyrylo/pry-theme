t = PryTheme.create :name => 'pry-siberia-8', :color_model => 8 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'This one reminds me of the cold Siberia... (just a tad)'

  define_theme do
    class_ 'blue'
    class_variable 'blue'
    comment 'yellow'
    constant 'blue'
    error 'white', 'blue'
    float 'yellow'
    global_variable 'yellow'
    inline_delimiter 'green'
    instance_variable 'blue'
    integer 'yellow'
    keyword 'cyan'
    method 'cyan'
    predefined_constant 'cyan'
    symbol 'cyan'

    regexp do
      self_ 'blue'
      char 'cyan'
      content 'blue'
      delimiter 'cyan'
      modifier 'blue'
      escape 'blue'
    end

    shell do
      self_ 'blue'
      char 'cyan'
      content 'blue'
      delimiter 'cyan'
      escape 'cyan'
    end

    string do
      self_ 'blue'
      char 'cyan'
      content 'blue'
      delimiter 'cyan'
      escape 'cyan'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
