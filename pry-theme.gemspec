unless defined? PryTheme::VERSION
  require File.expand_path('../lib/pry-theme/version', __FILE__)
end

Gem::Specification.new do |s|
  s.name         = "pry-theme"
  s.version      = PryTheme::VERSION
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = "Easy way to customize your Pry colors"
  s.description  = "The plugin enables color theme support for your Pry. No more .pryrc bustling."
  s.author       = "Kyrylo Silin"
  s.email        = "kyrylosilin@gmail.com"
  s.homepage     = "https://github.com/kyrylo/pry-theme"
  s.licenses     = "zlib"

  s.require_path = "lib"
  s.files        = `git ls-files`.split "\n"

  s.add_runtime_dependency "json"

  s.add_development_dependency "bacon"
  s.add_development_dependency "rake"
end
