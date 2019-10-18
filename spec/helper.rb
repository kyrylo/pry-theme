require 'bundler/setup'

require 'pry'
if Pry::VERSION < '0.11'
  require 'pry/test/helper'
else
  require 'pry/testable'
  include Pry::Testable
end

Bundler.require :default, :test

Pry.config.color = false
Pry.config.hooks = Pry::Hooks.new
Pry.config.pager = false
Pry.config.theme = nil

puts(
  "Ruby: #{RUBY_VERSION}; " +
  "Ruby Engine: #{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'}; " +
  "Pry Theme: #{PryTheme::VERSION}"
)
