t = PryTheme.create :name => 'pry-modern-256' do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Nifty version of pry-classic'

  define_theme do
    class_ 'fuchsia', [:bold]
    class_variable 'robin_egg_blue04'
    comment 'cerulean_grey01'
    constant 'klein_blue', [:bold, :underline]
    error 'cerulean_grey02'
    float 'dark_pink01', [:bold]
    global_variable 'gold'
    inline_delimiter 'malachite01', [:bold]
    instance_variable 'robin_egg_blue04'
    integer 'robin_egg_blue01', [:bold]
    keyword 'chestnut01', [:bold]
    method 'grass01', [:bold]
    predefined_constant 'cyan', [:bold]
    symbol 'malachite02', [:bold]

    regexp do
      self_ 'tangerine'
      char 'tangerine'
      content 'violaceous03'
      delimiter 'tangerine', [:bold]
      modifier 'dark_pink01', [:bold]
      escape 'malachite01', [:bold]
    end

    shell do
      self_ 'grass01'
      char 'grass01'
      content 'grass01'
      delimiter 'white'
      escape 'malachite01', [:bold]
    end

    string do
      self_ 'malachite01'
      char 'malachite01'
      content 'malachite01'
      delimiter 'malachite01', [:bold]
      escape 'malachite01', [:bold]
    end
  end
end

PryTheme::ThemeList.add_theme(t)
