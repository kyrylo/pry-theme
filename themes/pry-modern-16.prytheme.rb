t = PryTheme.create :name => 'pry-modern-16', :color_model => 16 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Simplied version of pry-modern-256'

  define_theme do
    class_ 'bright_magenta'
    class_variable 'bright_cyan'
    comment 'blue'
    constant 'bright_blue'
    error 'black', 'white'
    float 'bright_red'
    global_variable 'bright_yellow'
    inline_delimiter 'bright_green'
    instance_variable 'bright_cyan'
    integer 'bright_blue'
    keyword 'bright_red'
    method 'bright_yellow'
    predefined_constant 'bright_cyan'
    symbol 'bright_green'

    regexp do
      self_ 'bright_red'
      char 'bright_red'
      content 'magenta'
      delimiter 'red'
      modifier 'red'
      escape 'red'
    end

    shell do
      self_ 'bright_green'
      char 'bright_green'
      content 'green'
      delimiter 'green'
      escape 'green'
    end

    string do
      self_ 'bright_green'
      char 'bright_green'
      content 'green'
      delimiter 'green'
      escape 'green'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
