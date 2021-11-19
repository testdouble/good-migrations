module GoodMigrations
  def self.config(&blk)
    @configuration ||= Configuration.new

    @configuration.tap do |config|
      blk&.call(config)
    end
  end

  class Configuration
    # Migrations with timestamps (the numbers at the beginning of the file name) from
    # before this configured time will be allowed to perform autoloading, bypassing the
    # mechanism of this gem. Accepts:
    #   nil (default): never permit autoload
    #   String accepted by `Time.parse`, such as: 20211103150610 or 20211103_150610
    #   object responding to `to_time`, such as Date and Time
    attr_reader :permit_autoloading_before
    def permit_autoloading_before=(value)
      case value
      when nil
        # Stay nil
      when String
        value = Time.parse(value)
      else
        if value.respond_to?(:to_time)
          value = value.to_time
        else
          raise "Received an invalid value for permit_autoloading_before: #{value.inspect}"
        end
      end
      @permit_autoloading_before = value
    end

    # The error message that will be raised if a migration attempts to autoload.
    # The %{attempted_path} format parameter is available to indicate the
    # path of the file that would have been autoloaded.
    attr_accessor :load_error_message

    def initialize
      @load_error_message = <<~MSG
        Rails attempted to auto-load:

        %{attempted_path}

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

      MSG
      @permit_autoloading_before = nil
    end
  end
end
