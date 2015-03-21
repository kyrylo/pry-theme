t = PryTheme.create :name => 'pry-modern-8', :color_model => 8 do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Simplied version of pry-modern-16'

  define_theme do
    class_ 'magenta'
    class_variable 'cyan'
    comment 'blue'
    constant 'blue'
    error 'black', 'white'
    float 'red'
    global_variable 'yellow'
    inline_delimiter 'green'
    instance_variable 'cyan'
    integer 'blue'
    keyword 'red'
    method 'yellow'
    predefined_constant 'cyan'
    symbol 'green'

    regexp do
      self_ 'red'
      char 'red'
      content 'magenta'
      delimiter 'red'
      modifier 'red'
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
