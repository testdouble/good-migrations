require "active_support/dependencies"
require "good_migrations"

namespace :good_migrations do
  task :disable_autoload do
    next if ENV["GOOD_MIGRATIONS"] == "skip"
    GoodMigrations::PatchesAutoloader.instance.patch!
  end

  task :reenable_autoload do
    next if ENV["GOOD_MIGRATIONS"] == "skip"
    GoodMigrations::PatchesAutoloader.instance.unpatch!
  end
end

Rake::Task["db:migrate"].enhance(["good_migrations:disable_autoload"]) do
  Rake::Task["good_migrations:reenable_autoload"].invoke
end
