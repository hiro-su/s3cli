# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3cli/version'

Gem::Specification.new do |spec|
  spec.name          = "s3cli"
  spec.version       = S3cli::VERSION
  spec.authors       = ["hiro-su"]
  spec.email         = ["h.sugipon@gmail.com"]
  spec.description   = %q{SIMPLE AWS S3 CLI}
  spec.summary       = %q{SIMPLE AWS S3 CLI}
  spec.homepage      = "https://github.com/hiro-su/s3cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "aws-sdk", "~> 1.32.0"
  spec.add_dependency "thor", "~> 0.18.1"
  spec.add_dependency "parallel", "~> 0.9.2"
  spec.add_dependency "ruby-progressbar", "~> 1.4.1"
end
