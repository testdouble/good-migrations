module GoodMigrations
  class RaisesLoadError
    def raise!(path)
      error_message = format(GoodMigrations.config.load_error_message, attempted_path: path)
      raise GoodMigrations::LoadError, error_message
    end
  end
end
