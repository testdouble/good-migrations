require "test_helper"

class GoodMigrationsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GoodMigrations::VERSION
  end

  [:classic, :zeitwerk].each do |autoloader|
    define_method "test_good_migration_does_not_blow_up_#{autoloader}" do
      _, _, status = shell("AUTOLOADER=#{autoloader} bundle exec rake db:drop db:create db:migrate VERSION=20160202163803")

      assert_equal 0, status.exitstatus
    end

    define_method "test_rake_full_migrate_blows_up_#{autoloader}" do
      _, stderr, status = shell("AUTOLOADER=#{autoloader} bundle exec rake db:drop db:create db:migrate")

      assert_match(/GoodMigrations::LoadError: Rails attempted to auto-load:/, stderr)
      assert_match(/20160202182520_change_pants_dangerously.rb/, stderr)
      assert_match(/example\/app\/models\/pant.rb/, stderr)
      refute_equal 0, status.exitstatus
    end

    define_method "test_env_flag_prevents_explosion_#{autoloader}" do
      _, _, status = shell("AUTOLOADER=#{autoloader} GOOD_MIGRATIONS=skip bundle exec rake db:drop db:create db:migrate")

      assert_equal 0, status.exitstatus
    end

    define_method "test_patch_is_disabled_after_migrations_finish_#{autoloader}" do
      stdout, _, status = shell("AUTOLOADER=#{autoloader} bundle exec rake db:drop db:create db:migrate VERSION=20160202163803 load_pants")

      assert_match "This many pants: 0 pants", stdout
      assert_equal 0, status.exitstatus
    end

    define_method "test_permit_autoload_before_date_#{autoloader}" do
      _, stderr, status = shell("PERMIT_BEFORE_DATE=20170101000000 AUTOLOADER=#{autoloader} bundle exec rake db:drop db:create db:migrate")

      assert_match(/GoodMigrations::LoadError: Rails attempted to auto-load:/, stderr)
      assert_match(/20170102150000_change_shirts_dangerously.rb/, stderr)
      assert_match(/example\/app\/models\/shirt.rb/, stderr)
      refute_equal 0, status.exitstatus
    end
  end

  private

  def shell(command)
    script = <<-SCRIPT
      export BUNDLE_GEMFILE="Gemfile"
      export RAILS_ENV="development"
      rm -f db/*.sqlite3
      #{command}
    SCRIPT
    Bundler.with_unbundled_env do
      Open3.capture3(script, chdir: "example")
    end
  end
end
