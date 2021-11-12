$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "good_migrations"

require "minitest/autorun"
require "open3"
require "pry"

pre_test_setup_script = <<-SCRIPT
  export BUNDLE_GEMFILE="Gemfile"
  export RAILS_ENV="development"
  rm -f Gemfile.lock
  bundle install
SCRIPT
Bundler.with_unbundled_env do
  Open3.capture3(pre_test_setup_script, chdir: "example")
end
