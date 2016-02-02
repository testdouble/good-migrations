# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'good_migrations/version'

Gem::Specification.new do |spec|
  spec.name          = "good_migrations"
  spec.version       = GoodMigrations::VERSION
  spec.authors       = ["Justin Searls", "Kevin Baribeau"]
  spec.email         = ["searls@gmail.com", "kevin.baribeau@gmail.com"]

  spec.summary       = %q{Prevents Rails from auto-loading app code in database migrations}
  spec.description   = %q{Referencing code in app/ from a database migration risks breaking the migration when your app code changes; this gem prevents that mistake}
  spec.homepage      = "https://github.com/testdouble/good-migrations"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3.1"
  spec.add_dependency "activesupport", ">= 3.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
end
