# frozen_string_literal: true

require_relative "lib/tempus/version"

Gem::Specification.new do |spec|
  spec.name = "tempus"
  spec.version = Tempus::VERSION
  spec.authors = ["Danilo Jeremias da Silva"]
  spec.email = ["daniloj.dasilva@gmail.com"]

  spec.summary = "Gem to efficiently manipulate the time."
  spec.description = <<-DESCRIPTION
  Gem to efficiently manipulate the time.
  Adding, subtracting and converting more than 24 hours easy.'
  DESCRIPTION

  spec.homepage = "https://github.com/dannnylo/tempus"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "> 5"
  spec.metadata["rubygems_mfa_required"] = "true"
end
