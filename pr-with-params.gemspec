# frozen_string_literal: true

require_relative "lib/pr_with_params/version"

Gem::Specification.new do |spec|
  spec.name          = "pr-with-params"
  spec.version       = PRWithParams::VERSION
  spec.authors       = ["2k-joker"]
  spec.email         = ["kum.vanjunior@gmail.com"]

  spec.summary       = "Pushes current local branch to remote with upstream at origin/[local-branch-name]. It also opens a new pull request browser window at a URL with customized query params, based on specified options, which pre-populates certain fields in the pull request. This is especially useful when supporting multiple PR templates within a code base."
  spec.homepage      = "https://github.com/2k-joker/pr-with-params"
  spec.licenses      = ["MIT"]
  spec.required_ruby_version = Gem::Requirement.new("~> 3.1.0")

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "launchy", "~> 2.5"
  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "thor"
  spec.add_dependency "activesupport", "~> 7.0.4"

  spec.add_development_dependency "minitest", "~> 5.18.0"
  spec.add_development_dependency "rubocop", "~> 1.39"
  spec.add_development_dependency "rubocop-minitest", "~> 0.31.0"
  spec.add_development_dependency "minitest-stub_any_instance", "~> 1.0.3"
  spec.add_development_dependency "pry", "~> 0.13.1"
end
