# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strong_validations/version'

Gem::Specification.new do |spec|
  spec.name          = 'strong_validations'
  spec.version       = StrongValidations::VERSION
  spec.authors       = ['Brian Cardarella']
  spec.email         = ['bcardarella@gmail.com']
  spec.description   = %q{Context based validations for ActiveRecord models}
  spec.summary       = %q{Context based validations for ActiveRecord models}
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'm'
end
