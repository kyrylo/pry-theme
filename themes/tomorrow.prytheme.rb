t = PryTheme.create :name => 'tomorrow' do
  author :name => 'John Mair'
  description 'A theme should not get in your way'

  define_theme do
    class_ 'gold'
    class_variable 'alizarin'
    comment 'gray03'
    constant 'gold'
    error 'tangerine', [:italic]
    float 'tangerine'
    global_variable 'alizarin'
    inline_delimiter 'heliotrope01'
    instance_variable 'alizarin'
    integer 'tangerine'
    keyword 'heliotrope03'
    method 'royal_blue05'
    predefined_constant 'tangerine'
    symbol 'old_gold'

    regexp do
      self_ 'alizarin'
      char 'heliotrope01'
      content 'old_gold'
      delimiter 'alizarin'
      modifier 'old_gold'
      escape 'heliotrope01'
    end

    shell do
      self_ 'gray02'
      char 'heliotrope01'
      content 'puce01'
      delimiter 'gray02'
      escape 'heliotrope01'
    end

    string do
      self_ 'old_gold'
      char 'heliotrope01'
      content 'old_gold'
      delimiter 'old_gold'
      escape 'heliotrope01'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
