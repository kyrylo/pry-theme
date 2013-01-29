t = PryTheme.create name: 'pry-zealand-8', color_model: 8 do
  author name: 'Kyrylo Silin', email: 'kyrylosilin@gmail.com'
  description 'Feel the presence of New Zealand in your terminal'

  define_theme do
    class_ 'yellow'
    class_variable 'yellow'
    comment 'white'
    constant 'yellow'
    error 'black', 'yellow'
    float 'white'
    global_variable 'white'
    inline_delimiter 'green'
    instance_variable 'yellow'
    integer 'white'
    keyword 'green'
    method 'green'
    predefined_constant 'green'
    symbol 'green'

    regexp do
      self_ 'yellow'
      char 'green'
      content 'yellow'
      delimiter 'yellow'
      modifier 'green'
      escape 'green'
    end

    shell do
      self_ 'yellow'
      char 'green'
      content 'yellow'
      delimiter 'green'
      escape 'green'
    end

    string do
      self_ 'yellow'
      char 'green'
      content 'yellow'
      delimiter 'green'
      escape 'green'
    end
  end
end

PryTheme::ThemeList.add_theme(t)

