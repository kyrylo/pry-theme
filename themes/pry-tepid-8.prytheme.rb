t = PryTheme.create :name => 'pry-tepid-8', :color_model => 8 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Warm colors with warm soul'

  define_theme do
    class_ 'magenta'
    class_variable 'magenta'
    comment 'green'
    constant 'magenta'
    error 'black', 'magenta'
    float 'green'
    global_variable 'green'
    inline_delimiter 'yellow'
    instance_variable 'magenta'
    integer 'green'
    keyword 'yellow'
    method 'yellow'
    predefined_constant 'yellow'
    symbol 'yellow'

    regexp do
      self_ 'magenta'
      char 'yellow'
      content 'magenta'
      delimiter 'magenta'
      modifier 'yellow'
      escape 'yellow'
    end

    shell do
      self_ 'magenta'
      char 'yellow'
      content 'magenta'
      delimiter 'yellow'
      escape 'yellow'
    end

    string do
      self_ 'magenta'
      char 'yellow'
      content 'magenta'
      delimiter 'yellow'
      escape 'yellow'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
