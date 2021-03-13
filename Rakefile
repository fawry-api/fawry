# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)

task default: :rspec_rubocop

task :rspec_rubocop do
  Rake::Task['rubocop'].invoke
  Rake::Task['spec'].invoke
end

desc 'Start a console session with Fawry gem loaded'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'fawry'

  ARGV.clear
  IRB.start
end
