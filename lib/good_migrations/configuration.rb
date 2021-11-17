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

    def initialize
      @permit_autoloading_before = nil
    end
  end
end
