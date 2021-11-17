module GoodMigrations
  class RaisesLoadError
    def raise!(path)
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
