module GoodMigrations
  class Configuration
    class << self
      # Migrations with timestamps (the numbers at the beginning of the file name) from
      # before this configured time will be allowed to perform autoloading, bypassing the
      # mechanism of this gem. Accepts:
      #   nil: meaning never permit it
      #   String accepted by `Time.parse`, such as: 20211103150610 or 20211103_150610
      #   object responding to `to_time`, such as Date and Time
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
      attr_reader :permit_autoloading_before_date
      Configuration.permit_autoloading_before_date = nil
    end
  end
end
