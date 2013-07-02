# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blazemeter/version'

Gem::Specification.new do |spec|
  spec.name          = "blazemeter"
  spec.version       = Blazemeter::VERSION
  spec.authors       = ["Tamer Zoubi"]
  spec.email         = ["tamer.zoubi@blazemeter.com"]
  spec.homepage      = "http://blazemeter.com/"
  spec.description   = %q{Provide BlazeMeter functions as CLI}
  spec.summary       = %q{Provide BlazeMeter integration with Ruby}
  spec.homepage      = ""
  spec.license       = "MIT"
  
  spec.required_ruby_version     = '>= 1.9.3'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
