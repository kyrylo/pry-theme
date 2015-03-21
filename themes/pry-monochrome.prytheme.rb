t = PryTheme.create :name => 'pry-monochrome' do
  author :name => 'Kyrylo Silin', :email => 'silin@kyrylo.org'
  description 'For people who hate colors'

  define_theme do
    class_ [:bold, :underline]
    comment [:italic]
    constant [:bold]
    error [:bold, :italic, :underline]
    global_variable [:bold]
    inline_delimiter [:bold]
    keyword [:bold]
    method [:underline]
    predefined_constant [:italic]
    symbol [:underline]

    regexp do
      delimiter [:bold]
      modifier [:italic]
    end

    shell do
      delimiter [:bold]
    end

    string do
      delimiter [:bold]
    end
  end
end

PryTheme::ThemeList.add_theme(t)
