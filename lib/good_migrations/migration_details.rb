module GoodMigrations
  class MigrationDetails
    attr_reader :path
    def initialize(path)
      @path = path
    end

    def self.currently_executing
      migrate_dir_path = Rails.root.join("db/migrate/").to_s

      loc = caller.detect { |loc| loc.start_with?(migrate_dir_path) }
      return if loc.nil?
      
      end_index = loc.index(":", migrate_dir_path.size)

      new(loc[0...end_index])
    end

    def associated_time
      timestamp_string = File.basename(@path).partition("_").first
      return if timestamp_string.size != 14
      Time.parse(timestamp_string)
    end

    def considered_before?(time)
      return false if time.nil?
      my_time = associated_time
      return false if my_time.nil?
      my_time < time
    end
  end
end
