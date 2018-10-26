require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/extensiontask'

EXAMPLES_BASE_DIR = "examples/c"
EXAMPLES_BIN_DIR = "bin/examples"

CLEAN << EXAMPLES_BIN_DIR

RSpec::Core::RakeTask.new(:spec)

Rake::ExtensionTask.new ('sound_io') do |ext|
  ext.lib_dir = 'lib/sound_io'
end

task build: :compile

task 'compile:examples' => :clean do
  Dir.mkdir(EXAMPLES_BIN_DIR)

  lib_path = case Gem::Platform::local.os
  when 'osx'
    '/usr/local/lib/libsoundio.dylib'
  when 'linux' #?
    '/usr/local/lib/libsoundio.so.1' #?
  when 'windows'
    'C:/libsoundio/lib/libsoundio.dll'
  else
    raise "Unssuported OS: #{Gem::Platform::local.os}"
  end

  raise "#{lib_path} not found" unless File.exist?(lib_path)

  Dir["#{EXAMPLES_BASE_DIR}/*.c"].each do |c_file|
    exe_name = File.basename(c_file, '.c')
    libm = exe_name == 'play' ? '-lm' : ''
    out_path = "#{EXAMPLES_BIN_DIR}/#{exe_name}"
    puts `cc #{c_file} -L#{lib_path} -lsoundio #{libm} -o #{out_path}`
  end
end

task default: [:clobber, :compile, :spec]
