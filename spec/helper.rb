require 'rubygems'
require 'pry'
require 'pry/test/helper'

Pry.config.theme = nil
Pry.config.pager = false

unless Object.const_defined? 'PryTheme'
  $:.unshift File.expand_path '../../lib', __FILE__
  require 'pry-theme'
end

require 'bacon'

puts "Ruby: #{ RUBY_VERSION }; Ruby Engine: #{ defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby' }; " \
     "Pry Theme: #{ PryTheme::VERSION }"
