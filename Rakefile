require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :test => :spec
task :default => :spec

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'
