require 'rubygems'
require 'pry'

Pry.config.theme = nil

# Brute force or otherwise it won't work for all platforms.
begin
  $:.unshift File.expand_path('../../lib', __FILE__)
  require 'pry-theme'
rescue
end

require 'bacon'

puts "Ruby: #{ RUBY_VERSION }; Pry Theme: #{ PryTheme::VERSION }"
