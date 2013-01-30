# coding: utf-8

t = PryTheme.create :name => 'vim-detailed' do
  author :name => '☈king', :email => 'rking-pry-vim-detailed@sharpsaw.org'
  description "Lil' pal of http://www.vim.org/scripts/script.php?script_id=4297"

  define_theme do
    class_ 'vert_de_pomme02' # (originally: green)
    class_variable 'bluish01', 'flea_belly' # Intentionally ugly as a warning
    comment 'wet_asphalt07' # (originally: blue)
    constant 'vert_de_pomme01' # (originally: green)
    error 'black', 'bismarck_furious' # (originally: white, red)
    float 'titian' # (originally: red)
    global_variable 'cerise01', 'black03' # Intentionally ugly as chastisement
    inline_delimiter 'pale_mauve02', [:italic]
    instance_variable 'light_blue02' # (originally: cyan)
    integer 'bismarck_furious' # (originally: red)
    keyword 'magenta'
    method 'royal_blue02', [:bold] # (originally: cyan)
    predefined_constant 'pale_mauve02' # (originally: cyan)
    symbol 'cornflower_blue02' # (originally: red)

    regexp do
      self_ 'maroon01' # (originally: magenta)
      char 'red', 'black03' # (originally: red)
      content 'red', 'black03' # (originally: red)
      delimiter 'maroon01' # (originally: magenta)
      modifier 'lilac01' # (originally: magenta)
      escape 'violet_eggplant', [:bold]
    end

    shell do
      self_ 'pale_mauve02' # (originally: red)
      char 'eggplant02', 'black03'
      content 'eggplant02' # (originally: red)
      delimiter 'bright_violet', 'black03' # (originally: magenta)
      escape 'eggplant02', [:bold]
    end

    string do
      self_ 'titian' # (originally: red)
      char 'violet_eggplant01', 'black03'
      content 'bismarck_furious', 'black03'
      delimiter 'azure01' # (originally: magenta)
      escape 'violet_eggplant01', 'black03' # (originally: red)
    end
  end
end

PryTheme::ThemeList.add_theme(t)
