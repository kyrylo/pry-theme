require 'rubygems'
require 'pry'

# Brute force or otherwise it won't work for all platforms.
begin
  $:.unshift File.expand_path("../../lib", __FILE__)
  require 'pry-theme'
rescue
end

require 'bacon'

puts "Ruby version: #{RUBY_VERSION}; Pry Theme version: #{PryTheme::VERSION}"

class InputTester
  def initialize(*actions)
    @orig_actions = actions.dup
    @actions = actions
  end

  def readline(*)
    @actions.shift
  end

  def rewind
    @actions = @orig_actions.dup
  end
end

def mock_pry(*args)
  args.flatten!
  binding = args.first.is_a?(Binding) ? args.shift : binding()

  input = InputTester.new(*args)
  output = StringIO.new

  redirect_pry_io(input, output) do
    binding.pry
  end

  output.string
end

def redirect_pry_io(new_in, new_out = StringIO.new)
  old_in = Pry.input
  old_out = Pry.output

  Pry.input = new_in
  Pry.output = new_out
  begin
    yield
  ensure
    Pry.input = old_in
    Pry.output = old_out
  end
end
