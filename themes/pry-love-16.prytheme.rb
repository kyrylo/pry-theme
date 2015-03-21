t = PryTheme.create :name => 'pry-love-16', :color_model => 16 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Adds the love, expressed in 16 colors'

  define_theme do
    class_ 'bright_magenta'
    class_variable 'red'
    comment 'cyan'
    constant 'bright_magenta'
    error 'bright_yellow', 'magenta'
    float 'magenta'
    global_variable 'red'
    inline_delimiter 'red'
    instance_variable 'red'
    integer 'magenta'
    keyword 'bright_red'
    method 'bright_green'
    predefined_constant 'magenta'
    symbol 'magenta'

    regexp do
      self_ 'yellow'
      char 'yellow'
      content 'yellow'
      delimiter 'bright_red'
      modifier 'bright_yellow'
      escape 'bright_magenta'
    end

    shell do
      self_ 'yellow'
      char 'yellow'
      content 'yellow'
      delimiter 'bright_red'
      escape 'bright_magenta'
    end

    string do
      self_ 'yellow'
      char 'yellow'
      content 'yellow'
      delimiter 'bright_red'
      escape 'bright_magenta'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
