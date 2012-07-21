begin
  require 'pry'
  require 'pry-theme'

  PryTheme.install_gem_hooks
rescue LoadError
  # Be silent when we can't load Pry (when it's uninstalled).
end
