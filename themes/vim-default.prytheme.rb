# coding: utf-8

t = PryTheme.create :name => 'vim-default', :color_model => 8 do
  author :name => '☈king', :email => 'rking-pry-vimscheme@sharpsaw.org'
  description 'For those familiar with the default vim colorscheme'

  define_theme do
    class_ 'green'
    class_variable 'cyan'
    comment 'blue'
    constant 'green'
    error 'white', 'red'
    float 'red'
    global_variable 'cyan'
    inline_delimiter 'red'
    instance_variable 'cyan'
    integer 'red'
    keyword 'magenta' # some should be yellow. CodeRay's limited.
    method 'cyan'
    predefined_constant 'cyan'
    symbol 'red'

    regexp do
      self_ 'magenta'
      char 'red'
      content 'red'
      delimiter 'magenta'
      modifier 'magenta'
      escape 'red'
    end

    shell do
      self_ 'magenta'
      char 'red'
      content 'red'
      delimiter 'magenta'
      escape 'red'
    end

    string do
      self_ 'magenta'
      char 'red'
      content 'red'
      delimiter 'magenta'
      escape 'red'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
