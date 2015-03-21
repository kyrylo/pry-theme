t = PryTheme.create :name => 'pry-classic-16', :color_model => 16 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'The default Pry Theme for terminals with average color support'

  define_theme do
    class_ 'bright_magenta'
    class_variable 'bright_blue'
    comment 'blue'
    constant 'bright_blue'
    error 'bright_yellow', 'red'
    float 'bright_magenta'
    global_variable 'green'
    inline_delimiter 'red'
    instance_variable 'bright_blue'
    integer 'bright_blue'
    keyword 'bright_red'
    method 'bright_blue'
    predefined_constant 'bright_cyan'
    symbol 'bright_green'

    regexp do
      self_ 'red'
      char 'red'
      content 'red'
      delimiter 'bright_red'
      modifier 'bright_magenta'
      escape 'red'
    end

    shell do
      self_ 'green'
      char 'green'
      content 'bright_green'
      delimiter 'bright_green'
      escape 'green'
    end

    string do
      self_ 'green'
      char 'green'
      content 'bright_green'
      delimiter 'bright_green'
      escape 'green'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
