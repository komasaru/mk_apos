# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mk_apos/version'

Gem::Specification.new do |spec|
  spec.name          = "mk_apos"
  spec.version       = MkApos::VERSION
  spec.authors       = ["komasaru"]
  spec.email         = ["masaru@mk-mode.com"]

  spec.summary       = %q{Apparent position calculation tool.}
  spec.description   = %q{MkApos is a Apparent position calculation tool.}
  spec.homepage      = "https://github.com/komasaru/mk_apos"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "eph_bpn"
  spec.add_dependency "eph_jpl"
  spec.add_dependency "mk_coord"
  spec.add_dependency "mk_time"
  #spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "bundler", ">= 2.2.10"
  #spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
