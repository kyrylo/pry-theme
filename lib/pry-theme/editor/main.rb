module PryTheme::Editor
  class App < Sinatra::Base

    def self.edit(theme)
      chosen_theme(theme)
      run!
    end

    def self.chosen_theme(theme = nil)
      @theme = theme if theme
      @theme
    end

    get '/' do
      code_plates = PryTheme::ThemeList.themes.map { |t|
        CodePlate.new(t.definition, t.name) }

      cur_theme = code_plates.delete_at(code_plates.find_index { |code_plate|
        code_plate.name == App.chosen_theme.name })
      code_plates.unshift(cur_theme)

      erb :layout, :locals => { :code_plates => code_plates }
    end

  end
end
