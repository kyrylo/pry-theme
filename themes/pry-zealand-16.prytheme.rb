t = PryTheme.create :name => 'pry-zealand-16', :color_model => 16 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Feel the presence of green, ecologic and flourishing New Zealand in your terminal'

  define_theme do
    class_ 'bright_yellow'
    class_variable 'bright_yellow'
    comment 'magenta'
    constant 'bright_yellow'
    error 'black', 'bright_yellow'
    float 'bright_magenta'
    global_variable 'bright_magenta'
    inline_delimiter 'green'
    instance_variable 'bright_yellow'
    integer 'bright_magenta'
    keyword 'green'
    method 'bright_green'
    predefined_constant 'bright_green'
    symbol 'green'

    regexp do
      self_ 'bright_yellow'
      char 'bright_green'
      content 'bright_yellow'
      delimiter 'yellow'
      modifier 'green'
      escape 'green'
    end

    shell do
      self_ 'bright_yellow'
      char 'bright_green'
      content 'bright_yellow'
      delimiter 'green'
      escape 'green'
    end

    string do
      self_ 'bright_yellow'
      char 'bright_green'
      content 'bright_yellow'
      delimiter 'green'
      escape 'green'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
