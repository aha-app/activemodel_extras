# frozen_string_literal: true

require_relative "lib/activemodel-extra/version"

Gem::Specification.new do |spec|
  spec.name          = "activemodel-extra"
  spec.version       = ActiveModelExtra::VERSION
  spec.authors       = ["Aha! Dev Team"]
  spec.email         = ["dev@aha.io"]

  spec.summary       = %q{Extensions for ActiveModel providing array types, nested models, and array validation}
  spec.description   = %q{A collection of useful extensions to ActiveModel including array types, nested model support, and array validation}
  spec.homepage      = "https://github.com/aha-app/activemodel-extra"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/aha-app/activemodel-extra"
  spec.metadata["changelog_uri"] = "https://github.com/aha-app/activemodel-extra/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob("lib/**/*") + [
    "LICENSE",
    "README.md",
    "CHANGELOG.md",
  ]
  
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 6.0"
  spec.add_dependency "activesupport", ">= 6.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
 end
