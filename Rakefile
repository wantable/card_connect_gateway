require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :test => :spec
task :default => :spec

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

task :travis do # from http://docs.travis-ci.com/user/gui-and-headless-browsers/
  ["rake test", "rake jasmine:ci"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
