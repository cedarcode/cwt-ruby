# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cwt/version"

Gem::Specification.new do |spec|
  spec.name          = "cwt"
  spec.version       = CWT::VERSION
  spec.authors       = ["Gonzalo Rodriguez"]
  spec.email         = ["gonzalo@cedarcode.com"]

  spec.summary       = "Ruby implementation of RFC 8392 CBOR Web Token (CWT)"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/cedarcode/cwt-ruby"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "cbor", "~> 0.5.9"
  spec.add_dependency "cose", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "byebug", "~> 11.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rubocop", "~> 0.75.1"
  spec.add_development_dependency "rubocop-performance", "~> 1.4"
  spec.add_development_dependency "timecop", "~> 0.9.1"
end
