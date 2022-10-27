# frozen_string_literal: true

require_relative 'lib/tempus/version'

Gem::Specification.new do |spec|
  spec.name          = 'tempus'
  spec.version       = Tempus::VERSION
  spec.authors       = ['Danilo Jeremias da Silva']
  spec.email         = ['daniloj.dasilva@gmail.com']

  spec.summary       = 'Gem to efficiently manipulate the time.'
  spec.description   = <<-DESCRIPTION
  Gem to efficiently manipulate the time.
  Adding, subtracting and converting more than 24 hours easy.'
  DESCRIPTION

  spec.homepage      = 'https://github.com/dannnylo/tempus'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'activesupport', '> 5'
  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'simplecov', '~> 0.9'
end
