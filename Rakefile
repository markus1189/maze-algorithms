require 'rake'
require 'rspec/core/rake_task'
require 'rake/testtask'

task :default => [:ctags, :test_all]

desc "Run Rspecs"
RSpec::Core::RakeTask.new(:spec) do |t|
  #ruby_opts = "-w" TODO how to enable warings?
end

desc "Run the unit tests in test/unit"
Rake::TestTask.new('test') do |t|
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
end

desc "Test Rspec and Unit"
task :test_all => [:test, :spec] do
  #nothing
end

desc "Tag files for vim"
task :ctags do
  system "ctags -R *"
end

desc "Run benchmarks"
task :bench do
  cwd = File.expand_path(File.dirname(__FILE__))
  bench_dir = cwd + '/benchmarks/'
  (Dir.entries(bench_dir) - [".", ".."]).each do |bm|
    puts "Benchmarking: '#{bm}'"
    system "ruby #{bench_dir + bm}"
    puts
  end
end
