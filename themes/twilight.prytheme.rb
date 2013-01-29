t = PryTheme.create :name => 'twilight' do
  author :name => 'John Mair'
  description 'Based on Twilight from Emacs color-theme package'

  define_theme do
    class_ 'vert_de_peche'
    class_variable 'pale_cornflower_blue', [:bold]
    comment 'gray03'
    constant 'vert_de_peche'
    error 'tenne', [:italic]
    float 'silver01'
    global_variable 'pale_cornflower_blue'
    inline_delimiter 'pistachio01'
    instance_variable 'cornflower_blue02'
    integer 'pale_blue01'
    keyword 'brass02', [:bold]
    method 'ochre', [:bold]
    predefined_constant 'pale_cornflower_blue'
    symbol 'chestnut01'

    regexp do
      self_ 'moss_green'
      char 'pistachio01'
      content 'old_gold'
      delimiter 'moss_green'
      modifier 'pale_cornflower_blue'
      escape 'pistachio01'
    end

    shell do
      self_ 'moss_green'
      char 'pistachio01'
      content 'moss_green'
      delimiter 'moss_green'
      escape 'pistachio01'
    end

    string do
      self_ 'moss_green'
      char 'pistachio01'
      content 'moss_green'
      delimiter 'moss_green'
      escape 'pistachio01'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
