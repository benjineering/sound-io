lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sound_io/version'

Gem::Specification.new do |spec|
  spec.name = 'sound_io'
  spec.version = SoundIO::VERSION
  spec.authors = ['Ben Williams']
  spec.email = ['8enwilliams@gmail.com']

  spec.summary = 'An FFI wrapper for libsoundio'
  spec.license = 'MIT'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  
  spec.require_paths = ['lib']
  spec.extensions = ['ext/sound_io/extconf.rb']
  
  spec.add_dependency 'ffi', '~> 1.9'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rake-compiler', '~> 1.0'

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'simplecov'
end
