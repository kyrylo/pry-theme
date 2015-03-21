t = PryTheme.create :name => 'solarized' do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Precision colors for machines and people'

  define_theme do
    class_ 'dark_goldenrod'
    class_variable 'azure01'
    comment 'wet_asphalt05'
    constant 'dark_goldenrod'
    error 'abdel_kerims_beard04'
    float 'robin_egg_blue01'
    global_variable 'azure01'
    inline_delimiter 'titian'
    instance_variable 'azure01'
    integer 'robin_egg_blue01'
    keyword 'gray03', [:bold]
    method 'azure01'
    predefined_constant 'azure01'
    symbol 'robin_egg_blue01'

    regexp do
      self_ 'olive_drab'
      char 'titian'
      content 'olive_drab'
      delimiter 'titian'
      modifier 'titian'
      escape 'titian'
    end

    shell do
      self_ 'titian'
      char 'titian'
      content 'robin_egg_blue01'
      delimiter 'titian'
      escape 'titian'
    end

    string do
      self_ 'titian'
      char 'titian'
      content 'robin_egg_blue01'
      delimiter 'titian'
      escape 'robin_egg_blue01'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
