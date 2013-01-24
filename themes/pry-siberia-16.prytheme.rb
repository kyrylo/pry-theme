t = PryTheme.create name: 'pry-cold-8', color_model: 8 do
  author name: 'Kyrylo Silin', email: 'kyrylosilin@gmail.com'
  author name: 'John Mair'
  description 'Based on Charcoalblack theme from Emacs'

  define_theme do
    #class_ 'magenta'
    #class_variable 'cyan'
    #comment 'blue'
    #constant 'blue'
    #error 'yellow', 'red'
    #float 'magenta'
    #global_variable bg: 'green'
    #integer 'blue'
    #keyword 'red'
    #method 'blue'
    #predefined_constant 'cyan'
    #symbol 'green'

    #regexp do
      #self_ 'red'
      #content 'red'
      #delimiter 'red'
      #modifier 'magenta'
    #end

    #shell do
      #self_ bg: 'green'
      #delimiter 'white'
    #end

    #string do
      #self_ 'green'
      #content 'green'
      #delimiter 'green'
    #end
  end
end
