def quiet
  ENV['VERBOSE'] ? '' : '-q'
end

def test_files
  paths = FileList['spec/**/*_spec.rb']
  paths.shuffle!.join(' ')
end

desc "Run tests"
task :test do
  exec "bacon -Ispec #{ quiet } #{ test_files }"
end

task :default => :test
