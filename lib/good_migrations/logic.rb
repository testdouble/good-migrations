module GoodMigrations
  class Logic
    def self.currently_executing_migration_path
      migrate_dir_path = Rails.root.join("db/migrate/").to_s
      loc = caller.detect { |loc| loc.start_with?(migrate_dir_path) }
      return if loc.nil?
      loc.partition(":").first
    end

    def self.extract_time_from_migration_path(path)
      timestamp_string = File.basename(path).partition("_").first
      return if timestamp_string.size != 14
      Time.parse(timestamp_string)
    end

    def self.permit_autoloading_based_on_migration_time?
      return false if GoodMigrations::Configuration.permit_autoloading_before_date.nil?

      migration_path = currently_executing_migration_path
      return false if migration_path.nil?

      migration_time = extract_time_from_migration_path(migration_path)
      # Or should this raise?
      return false if migration_time.nil?

      migration_time < GoodMigrations::Configuration.permit_autoloading_before_date
    end

    def self.permit_autoloading_of_path?(path)
      !app_path?(path) || permit_autoloading_based_on_migration_time?
    end

    def self.app_path?(path)
      path.starts_with? File.join(Rails.application.root, "app")
    end

    def self.prevent_load!(path)
      raise GoodMigrations::LoadError, <<-ERROR.strip_heredoc
        Rails attempted to auto-load:

        #{path}

        Which is in your project's `app/` directory. The good_migrations
        gem was designed to prevent this, because migrations are intended
        to be immutable and safe-to-run for the life of your project, but
        code in `app/` is liable to change at any time.

        The most common reason for this error is that you may be referencing an
        ActiveRecord model inside the migration in order to use the ActiveRecord API
        to implement a data migration by querying and updating objects.

        For instance, if you want to access a model "User" in your migration, it's safer
        to redefine the class inside the migration instead, like this:

        class MakeUsersOlder < ActiveRecord::Migration
          class User < ActiveRecord::Base
            # Define whatever you need on the User beyond what AR adds automatically
          end

          def up
            User.find_each do |user|
              user.update!(:age => user.age + 1)
            end
          end

          def down
            #...
          end
        end

        For more information, visit:

        https://github.com/testdouble/good-migrations

      ERROR
    end
  end
end
