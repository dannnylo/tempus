# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tempus/version'

Gem::Specification.new do |spec|
  spec.name          = 'tempus'
  spec.version       = Tempus::VERSION
  spec.authors       = ['Danilo Jeremias da Silva']
  spec.email         = ['daniloj.dasilva@gmail.com']

  spec.summary       = 'Gem to efficiently manipulate the time, adding, subtracting and converting hours.'
  spec.description   = 'Gem to efficiently manipulate the time, adding, subtracting and converting hours.'
  spec.homepage      = 'https://github.com/dannnylo/tempus'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib', 'lib/tempus']
  spec.add_runtime_dependency 'activesupport', '> 5'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'simplecov', '~> 0.1'
end
