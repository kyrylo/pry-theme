t = PryTheme.create :name => 'pry-classic-256' do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'The default Pry Theme'

  define_theme do
    class_ 'pale_red_violet03', [:bold]
    class_variable 'cerulean_grey02'
    comment 'wisteria02'
    constant 'blue'
    error 'yellow', 'red'
    float 'magenta'
    global_variable 'lime02'
    inline_delimiter 'red'
    instance_variable 'cerulean_grey02'
    integer 'blue'
    keyword 'red'
    method 'blue', [:bold]
    predefined_constant 'robin_egg_blue04'
    symbol 'green'

    regexp do
      self_ 'red'
      char 'pale_red_violet03'
      content 'eggplant02'
      delimiter 'red', [:bold]
      modifier 'magenta', [:underline]
      escape 'red'
    end

    shell do
      self_ 'green'
      char 'dark_spring_green'
      content 'green'
      delimiter 'green', [:bold]
      escape 'dark_spring_green'
    end

    string do
      self_ 'green'
      char 'dark_spring_green'
      content 'green'
      delimiter 'green', [:bold]
      escape 'dark_spring_green'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
