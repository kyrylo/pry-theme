t = PryTheme.create :name => 'pry-classic-8', :color_model => 8 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'The default Pry Theme for terminals with poor color support'

  define_theme do
    class_ 'magenta'
    class_variable 'blue'
    comment 'blue'
    constant 'blue'
    error 'yellow', 'red'
    float 'magenta'
    global_variable 'green'
    inline_delimiter 'red'
    instance_variable 'blue'
    integer 'blue'
    keyword 'red'
    method 'blue'
    predefined_constant 'cyan'
    symbol 'green'

    regexp do
      self_ 'red'
      char 'red'
      content 'red'
      delimiter 'red'
      modifier 'magenta'
      escape 'red'
    end

    shell do
      self_ 'green'
      char 'green'
      content 'green'
      delimiter 'green'
      escape 'green'
    end

    string do
      self_ 'green'
      char 'green'
      content 'green'
      delimiter 'green'
      escape 'green'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
