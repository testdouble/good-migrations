require "rubygems"

# Set up gems listed in the Gemfile.
gemfile = File.expand_path("../../Gemfile", __FILE__)
if File.exist?(gemfile)
  begin
    ENV["BUNDLE_GEMFILE"] = gemfile
    require "bundler"
    Bundler.setup
  rescue Bundler::GemNotFound => e
    warn e.message
    warn "Try running `bundle install`."
    exit!
  end
end
# Fix concurrent-ruby removing logger dependency which Rails was transitively
# depending on.
require "logger"
require "bootsnap/setup"
