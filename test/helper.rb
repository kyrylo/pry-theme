require 'pry'
require 'bacon'

require "#{ File.dirname(__FILE__) }/../lib/pry-theme"

puts "Ruby version: #{RUBY_VERSION}; Pry Theme version: #{PryTheme::VERSION}"
