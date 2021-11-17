GoodMigrations.config do |config|
  # Setting `permit_autoloading_before` will DISABLE good_migrations for
  # any migrations before the given time. Don't set this unless you need to!
  #
  # Accepts parseable time strings as well as `Date` & `Time` objects
  config.permit_autoloading_before = ENV["PERMIT_AUTOLOADING_BEFORE"]
end
