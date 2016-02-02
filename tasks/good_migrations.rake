require 'active_support/dependencies'
require 'good_migrations'

namespace :good_migrations do
  task :disable_autoload do
    next if ENV['GOOD_MIGRATIONS'] == "skip"
    ActiveSupport::Dependencies.class_eval do
      extend Module.new {
        def load_file(path, const_paths = loadable_constants_for_path(path))
          if path.starts_with? File.join(Rails.application.root, 'app')
            raise GoodMigrations::LoadError, <<-ERROR
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
          else
            super
          end
        end
      }
    end
  end
end

Rake.application.in_namespace('db:migrate') do |namespace|
  ([Rake::Task['db:migrate']] + namespace.tasks).each do |task|
    task.prerequisites << "good_migrations:disable_autoload"
  end
end

