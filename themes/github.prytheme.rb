t = PryTheme.create :name => 'github' do
  author :name => 'John Mair'
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'Based on GitHub theme'

  define_theme do
    class_ 'seroburomalinovyj01', [:bold]
    class_variable 'teal01'
    comment 'gray01'
    constant 'teal'
    error 'bismarck_furious', 'periwinkle'
    float 'teal01'
    global_variable 'teal01'
    inline_delimiter 'cerise01'
    instance_variable 'teal01'
    integer 'teal01'
    keyword 'black', [:bold]
    method 'maroon', [:bold]
    predefined_constant 'teal01'
    symbol 'violet_eggplant01'

    regexp do
      self_ 'toad_in_love01'
      char 'toad_in_love01'
      content 'toad_in_love01'
      delimiter 'toad_in_love01'
      modifier 'toad_in_love01'
      escape 'toad_in_love01'
    end

    shell do
      self_ 'cerise01'
      char 'cerise01'
      content 'cerise01'
      delimiter 'cerise01'
      escape 'cerise01'
    end

    string do
      self_ 'cerise01'
      char 'cerise01'
      content 'cerise01'
      delimiter 'cerise01'
      escape 'cerise01'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
