# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'context_validations/version'

Gem::Specification.new do |spec|
  spec.name          = 'context_validations'
  spec.version       = ContextValidations::VERSION
  spec.authors       = ['Brian Cardarella']
  spec.email         = ['bcardarella@gmail.com']
  spec.description   = %q{Context based validations for ActiveRecord models}
  spec.summary       = %q{Context based validations for ActiveRecord models}
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'm'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'sqlite3'
end
