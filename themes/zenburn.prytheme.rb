t = PryTheme.create :name => 'zenburn' do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'A low-contrast color scheme'

  define_theme do
    class_ 'dark_peach', [:bold]
    class_variable 'dark_peach'
    comment 'swamp_green01'
    constant 'dark_peach', [:bold]
    error 'tenne', [:italic]
    float 'silver01'
    global_variable 'dark_peach'
    inline_delimiter 'gray02'
    instance_variable 'dark_peach'
    integer 'pale_blue01'
    keyword 'dark_salmon', [:bold]
    method 'corn02'
    predefined_constant 'dark_peach'
    symbol 'puce01', [:bold]

    regexp do
      self_ 'gray02'
      char 'gray02'
      content 'puce01'
      delimiter 'gray02'
      modifier 'gray02'
      escape 'gray02'
    end

    shell do
      self_ 'gray02'
      char 'gray02'
      content 'puce01'
      delimiter 'gray02'
      escape 'gray02'
    end

    string do
      self_ 'gray02'
      char 'gray02'
      content 'puce01'
      delimiter 'gray02'
      escape 'gray02'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
