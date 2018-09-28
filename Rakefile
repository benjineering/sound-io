require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/extensiontask'

RSpec::Core::RakeTask.new(:spec)

Rake::ExtensionTask.new ('sound_io') do |ext|
  ext.lib_dir = 'lib/sound_io'
end

task build: :compile

task default: [:clobber, :compile, :spec]
