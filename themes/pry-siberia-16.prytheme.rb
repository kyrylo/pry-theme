t = PryTheme.create :name => 'pry-siberia-16', :color_model => 16 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'This one reminds me of the cold Siberia...'

  define_theme do
    class_ 'bright_blue'
    class_variable 'bright_blue'
    comment 'yellow'
    constant 'bright_blue'
    error 'white', 'bright_blue'
    float 'bright_yellow'
    global_variable 'bright_yellow'
    inline_delimiter 'green'
    instance_variable 'bright_blue'
    integer 'bright_yellow'
    keyword 'cyan'
    method 'bright_cyan'
    predefined_constant 'bright_cyan'
    symbol 'cyan'

    regexp do
      self_ 'bright_blue'
      char 'bright_cyan'
      content 'bright_blue'
      delimiter 'blue'
      modifier 'cyan'
      escape 'cyan'
    end

    shell do
      self_ 'bright_blue'
      char 'bright_cyan'
      content 'bright_blue'
      delimiter 'cyan'
      escape 'cyan'
    end

    string do
      self_ 'bright_blue'
      char 'bright_cyan'
      content 'bright_blue'
      delimiter 'cyan'
      escape 'cyan'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
