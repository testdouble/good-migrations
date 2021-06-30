require "good_migrations/version"
require "good_migrations/load_error"
require "good_migrations/patches_autoloader"
require "good_migrations/prevents_app_load"
require "good_migrations/railtie" if defined?(Rails)
