module GoodMigrations
  class PermitsAutoload
    def permit?(path)
      !app_path?(path) || permit_autoloading_based_on_migration_time?
    end

    private

    def permit_autoloading_based_on_migration_time?
      permit_before_date = GoodMigrations.config.permit_autoloading_before
      migration_details = GoodMigrations::MigrationDetails.currently_executing
      migration_details.considered_before?(permit_before_date)
    end

    def app_path?(path)
      path.starts_with? File.join(Rails.application.root, "app")
    end
  end
end
