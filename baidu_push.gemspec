# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'baidu_push/version'

Gem::Specification.new do |spec|
  spec.name          = "baidu_push"
  spec.version       = BaiduPush::VERSION
  spec.authors       = ["David Ruan"]
  spec.email         = ["ruanwz@gmail.com"]
  spec.summary       = %q{Baidu Push SDK}
  spec.description   = %q{Baidu Push SDK}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus", "~> 1.0.4"
  spec.add_dependency "faraday", "~> 0.9.1"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "pry", "~> 0.10.1"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "webmock", "~> 1.20.2"
  spec.add_development_dependency "timecop", "~> 0.7.1"
end
