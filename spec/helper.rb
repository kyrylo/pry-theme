require 'rubygems'
require 'pry'
require 'pry/test/helper'

Pry.config.theme = nil

unless Object.const_defined? 'PryTheme'
  $:.unshift File.expand_path '../../lib', __FILE__
  require 'pry-theme'
end

require 'bacon'

puts "Ruby: #{ RUBY_VERSION }; Ruby Engine: #{ RUBY_ENGINE }; Pry Theme: #{ PryTheme::VERSION }"
