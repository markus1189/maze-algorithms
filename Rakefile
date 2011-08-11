require 'rake'
require 'rspec/core/rake_task'
require 'rake/testtask'

task :default => [:ctags, :test_all]

desc "Run Rspecs"
RSpec::Core::RakeTask.new(:spec)

desc "Run the unit tests in test/unit"
Rake::TestTask.new('test') do |t|
  t.pattern = 'test/**/*_test.rb'
  t.warning, t.verbose = true, true
end

desc "Test Rspec and Unit"
task :test_all => [:test, :spec] do
  #nothing
end

desc "Tag files for vim"
task :ctags do
  system "ctags -R *"
end

