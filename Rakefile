SOFT_DEPS = %w|sinatra random-word|

def check_soft_deps
  SOFT_DEPS.map do |dep|
    begin
      !!Gem::Specification.find_by_name(dep)
    rescue Gem::LoadError
      false
    end
  end
end

def quiet
  ENV['VERBOSE'] ? '' : '-q'
end

def test_files
  paths = FileList['spec/**/*_spec.rb']
  unless check_soft_deps.all?
    warn <<-WARN
\e[31;1mWARNING:\e[0m Install the following soft pry-theme dependencies
         in order to run all tests: #{ SOFT_DEPS.join(', ') }.
         Run `rake install_deps` in order to install the
         dependencies.
    WARN
    paths = paths.exclude('spec/editor/*')
  end
  paths.shuffle!.join(' ')
end

desc "Run tests"
task :test do
  exec "bacon -Ispec #{ quiet } #{ test_files }"
end

desc "Install all soft dependencies (required for the editor)"
task :install_deps do
  puts 'Installing dependencies...'
  `gem install #{ SOFT_DEPS.join(' ') }`
  puts 'Done.'
end

task :default => :test
