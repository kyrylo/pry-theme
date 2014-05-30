require 'bundler/setup'
require 'pry/test/helper'

Bundler.require :default, :test

Pry.config.theme = nil
Pry.config.pager = false

puts(
  "Ruby: #{RUBY_VERSION}; " +
  "Ruby Engine: #{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'}; " +
  "Pry Theme: #{PryTheme::VERSION}"
)
