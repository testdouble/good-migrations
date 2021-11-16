module GoodMigrations
  def self.config
    @configuration ||= Configuration.new
  end

  class Configuration
    # Migrations with timestamps (the numbers at the beginning of the file name) from
    # before this configured time will be allowed to perform autoloading, bypassing the
    # mechanism of this gem. Accepts:
    #   nil (default): never permit autoload
    #   String accepted by `Time.parse`, such as: 20211103150610 or 20211103_150610
    #   object responding to `to_time`, such as Date and Time
    attr_reader :permit_autoloading_before_date
    def permit_autoloading_before_date=(value)
      case value
      when nil
        # Stay nil
      when String
        value = Time.parse(value)
      else
        if value.respond_to?(:to_time)
          value = value.to_time
        else
          raise "Received an invalid value for permit_autoloading_before_date: #{value.inspect}"
        end
      end
      @permit_autoloading_before_date = value
    end

    def initialize
      @permit_autoloading_before_date = nil
    end
  end
end
