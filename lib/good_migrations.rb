require "time"

require_relative "good_migrations/version"
require_relative "good_migrations/load_error"
require_relative "good_migrations/migration_details"
require_relative "good_migrations/configuration"
require_relative "good_migrations/patches_autoloader"
require_relative "good_migrations/permits_autoload"
require_relative "good_migrations/raises_load_error"
require_relative "good_migrations/railtie" if defined?(Rails)
