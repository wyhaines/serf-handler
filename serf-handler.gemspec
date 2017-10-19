# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "serf/handler/version"

Gem::Specification.new do |spec|
  spec.name          = "serf-handler"
  spec.version       = Serf::Handler::VERSION
  spec.authors       = ["Kirk Haines"]
  spec.email         = ["wyhaines@gmail.com"]

  spec.summary       = %q{This is a framework for a modular handler for serf.}
  spec.description   = <<~EDESC
    This is a framework for creating handlers for serf, by Hashicorp. The handlers
    are modular, loading themselves according to a configuration file that
    indicates what commands are supported, and where to load the code for those
    commands. The framework will also support executing the handler on the
    command line, with the serf payload provided on the command line. This is
    useful for testing.
  EDESC
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
