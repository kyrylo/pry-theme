Gem::Specification.new do |s|
  s.name         = 'pry-theme'
  s.version      = File.read('VERSION')
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = 'An easy way to customize Pry colors via theme files'
  s.description  = 'The plugin enables color theme support for Pry.'
  s.author       = 'Kyrylo Silin'
  s.email        = 'silin@kyrylo.org'
  s.homepage     = 'https://github.com/kyrylo/pry-theme'
  s.licenses     = 'zlib'

  s.require_path = 'lib'
  s.files        = `git ls-files`.split("\n")

  s.add_dependency 'coderay', '~> 1.1'

  s.add_development_dependency 'bundler', '~> 1.0'
end
