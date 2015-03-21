t = PryTheme.create :name => 'pry-love-8', :color_model => 8 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Adds the love, expressed in 8 colors'

  define_theme do
    class_ 'magenta'
    class_variable 'red'
    comment 'cyan'
    constant 'magenta'
    error 'yellow', 'magenta'
    float 'magenta'
    global_variable 'red'
    inline_delimiter 'red'
    instance_variable 'red'
    integer 'magenta'
    keyword 'red'
    method 'green'
    predefined_constant 'magenta'
    symbol 'magenta'

    regexp do
      self_ 'yellow'
      char 'yellow'
      content 'yellow'
      delimiter 'red'
      modifier 'yellow'
      escape 'magenta'
    end

    shell do
      self_ 'yellow'
      char 'yellow'
      content 'yellow'
      delimiter 'red'
      escape 'magenta'
    end

    string do
      self_ 'yellow'
      char 'yellow'
      content 'yellow'
      delimiter 'red'
      escape 'magenta'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
