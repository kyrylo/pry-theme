t = PryTheme.create :name => 'pry-tepid-16', :color_model => 16 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Warm colors with warm soul'

  define_theme do
    class_ 'bright_magenta'
    class_variable 'bright_magenta'
    comment 'green'
    constant 'bright_magenta'
    error 'black', 'bright_magenta'
    float 'bright_green'
    global_variable 'bright_green'
    inline_delimiter 'yellow'
    instance_variable 'bright_magenta'
    integer 'bright_green'
    keyword 'yellow'
    method 'bright_yellow'
    predefined_constant 'bright_yellow'
    symbol 'yellow'

    regexp do
      self_ 'bright_magenta'
      char 'bright_yellow'
      content 'bright_magenta'
      delimiter 'magenta'
      modifier 'yellow'
      escape 'yellow'
    end

    shell do
      self_ 'bright_magenta'
      char 'bright_yellow'
      content 'bright_magenta'
      delimiter 'yellow'
      escape 'yellow'
    end

    string do
      self_ 'bright_magenta'
      char 'bright_yellow'
      content 'bright_magenta'
      delimiter 'yellow'
      escape 'yellow'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
