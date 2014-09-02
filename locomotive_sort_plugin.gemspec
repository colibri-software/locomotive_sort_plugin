# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locomotive/sort/plugin/version'

Gem::Specification.new do |spec|
  spec.name          = "locomotive_sort_plugin"
  spec.version       = Locomotive::Sort::VERSION
  spec.authors       = ["Charlie Greene"]
  spec.email         = ["greeneca@gmail.com"]
  spec.summary       = %q{Variable sort content entries}
  spec.description   = %q{Allows designers to sort content types multiple different ways.}
  spec.homepage      = "http://colibri-software.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "locomotive_plugins", '~> 1.0'
end
