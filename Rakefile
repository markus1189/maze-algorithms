require 'rake'
require 'rspec/core/rake_task'
require 'rake/testtask'

task :default => [:ctags, :spec]

desc "Run Rspecs"
RSpec::Core::RakeTask.new(:spec)

desc "Run the unit tests in test/unit"
Rake::TestTask.new('test') do |t|
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
end

desc "Tag files for vim"
task :ctags do
  system "ctags -R *"
end

desc "Run benchmarks"
task :bench do
  cwd = File.expand_path(File.dirname(__FILE__))
  Dir.glob("**/*_bm.rb").each do |bm|
    puts "Benchmarking: '#{bm}'"
    system "ruby #{bm}"
    puts "="*80
  end
end

desc "Look for TODO and FIXME tags in the code"
task :todo do
  FileList['**/*.rb'].egrep(/#.*(FIXME|TODO|NOTE)/)
end
