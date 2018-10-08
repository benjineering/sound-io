require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/extensiontask'

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new('spec:c_api') do |t|
  t.rspec_opts = "--tag c_api"
end

Rake::ExtensionTask.new ('sound_io') do |ext|
  ext.lib_dir = 'lib/sound_io'
end

task build: :compile

task ext: [:clobber, :compile, 'spec:c_api']

task default: [:clobber, :compile, :spec]
