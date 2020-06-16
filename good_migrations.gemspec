lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "good_migrations/version"

Gem::Specification.new do |spec|
  spec.name = "good_migrations"
  spec.version = GoodMigrations::VERSION
  spec.authors = ["Justin Searls", "Kevin Baribeau"]
  spec.email = ["searls@gmail.com", "kevin.baribeau@gmail.com"]

  spec.summary = "Prevents Rails from auto-loading app code in database migrations"
  spec.description = "Referencing code in app/ from a database migration risks breaking the migration when your app code changes; this gem prevents that mistake"
  spec.homepage = "https://github.com/testdouble/good-migrations"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 3.1"
  spec.add_dependency "activerecord", ">= 3.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "standard"
end
