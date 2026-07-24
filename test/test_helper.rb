$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "good_migrations"

# Fix concurrent-ruby removing logger dependency which Rails was transitively
# depending on.
require "logger"
require "minitest/autorun"
require "open3"
require "pry"

Bundler.with_unbundled_env do
  Open3.capture3("bin/setup", chdir: "example")
end
