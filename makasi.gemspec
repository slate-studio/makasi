# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'makasi/version'

Gem::Specification.new do |spec|
  spec.name          = "makasi"
  spec.version       = Makasi::VERSION
  spec.authors       = ["Nataliia Kumeiko"]
  spec.email         = ["nkumeiko@gmail.com"]

  spec.summary       = "An easy way to index sitemap and search through it. Based on Amazon CloudSearch."
  spec.homepage      = "http://slatestudio.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "asari", "0.10.4"
  spec.add_dependency "sitemap_generator"
end
