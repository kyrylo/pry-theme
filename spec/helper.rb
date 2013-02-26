require 'rubygems'
require 'pry'
require 'pry/test/helper'

Pry.config.theme = nil
Pry.config.pager = false

unless Object.const_defined? 'PryTheme'
  $:.unshift File.expand_path '../../lib', __FILE__
  require 'pry-theme'
end

unless defined?(PryTheme::Editor)
  warn "\e[31;1mWARNING:\e[0m Install the following soft pry-theme dependencies in order" \
    " to run \e[1mall tests\e[0m: sinatra, random-word.\n         Running only a part of tests..."
end

require 'bacon'

puts "Ruby: #{ RUBY_VERSION }; Ruby Engine: #{ defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby' }; " \
     "Pry Theme: #{ PryTheme::VERSION }"
