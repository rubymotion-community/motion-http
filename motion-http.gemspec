# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name          = "motion-http"
  spec.version       = "1.0.2"
  spec.authors       = ["Andrew Havens"]
  spec.email         = ["email@andrewhavens.com"]
  spec.description   = %q{A cross-platform HTTP client for RubyMotion that's quick and easy to use.}
  spec.summary       = %q{A cross-platform HTTP client for RubyMotion that's quick and easy to use.}
  spec.homepage      = "https://github.com/rubymotion-community/motion-http"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'motion-lager'
end
