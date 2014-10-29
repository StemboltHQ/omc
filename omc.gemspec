# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omc/version'

Gem::Specification.new do |spec|
  spec.name          = "omc"
  spec.version       = Omc::VERSION
  spec.authors       = ["Clarke Brunsdon"]
  spec.email         = ["clarke@freerunningtechnologies.com"]
  spec.summary       = %q{Opsworks Missing Console - Useful Commands for Opsworks}
  spec.homepage      = "http://github.com/freerunningtech/omc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", '~> 0.19'
  spec.add_dependency "aws_cred_vault", '~> 0.0'
  spec.add_dependency "aws-sdk", '~> 1.56'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
