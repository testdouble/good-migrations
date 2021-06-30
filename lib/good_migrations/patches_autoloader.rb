module GoodMigrations
  class PatchesAutoloader
    def self.instance
      @instance ||= new
    end

    def initialize
      @disabled = false
    end

    def disabled?
      @disabled
    end

    def patch!
      if Rails.singleton_class.method_defined?(:autoloaders) &&
          Rails.autoloaders.zeitwerk_enabled?
        if Rails.autoloaders.main.respond_to?(:on_load) &&
            Rails.autoloaders.main.method(:on_load).arity <= 0
          @disabled = false
          Rails.autoloaders.each do |loader|
            loader.on_load do |_, _, path|
              if GoodMigrations::PreventsAppLoad.app_path?(path) &&
                  !GoodMigrations::PatchesAutoloader.instance.disabled?
                GoodMigrations::PreventsAppLoad.prevent_load!(path)
              end
            end
          end
        else
          warn <<~UNSUPPORTED
            WARNING: good_migrations is unable to ensure that your migrations are
              not inadvertently loading application code, because your application
              uses the zeitwerk autoloader (`config.autoloader = :zeitwerk`), but
              is using a version prior to zeitwerk 2.5.0, which adds an on_load
              hook that good_migrations can latch onto.

            Solution: Ensure that zeitwerk isn't pinned below 2.5.0 in your
              Gemfile and try running `bundle update zeitwerk`.

          UNSUPPORTED
        end
      else
        @disabled = false
        ActiveSupport::Dependencies.class_eval do
          extend Module.new {
            def load_file(path, const_paths = loadable_constants_for_path(path))
              if GoodMigrations::PreventsAppLoad.app_path?(path) &&
                  !GoodMigrations::PatchesAutoloader.instance.disabled?
                GoodMigrations::PreventsAppLoad.prevent_load!(path)
              else
                super
              end
            end
          }
        end
      end
    end

    def unpatch!
      @disabled = true
    end
  end
end
