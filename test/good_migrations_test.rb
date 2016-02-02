require 'test_helper'

class GoodMigrationsTest < Minitest::Test
  def setup
    @script_setup = <<-BASH
      cd example
      bundle
    BASH
  end

  def test_that_it_has_a_version_number
    refute_nil ::GoodMigrations::VERSION
  end

  def test_good_migration_does_not_blow_up
    stdout, stderr, status = shell("bundle exec rake db:drop db:create db:migrate VERSION=20160202163803")

    assert_equal 0, status.exitstatus
  end

  def test_rake_full_migrate_blows_up
    stdout, stderr, status = shell("bundle exec rake db:drop db:create db:migrate")

    assert_match /GoodMigrations::LoadError: Rails attempted to auto-load:/, stderr
    assert_match /example\/app\/models\/pant.rb/, stderr
    refute_equal 0, status.exitstatus
  end

  def test_env_flag_prevents_explosion
    stdout, stderr, status = shell("GOOD_MIGRATIONS=skip bundle exec rake db:drop db:create db:migrate")

    assert_equal 0, status.exitstatus
  end

private

  def shell(command)
    script = <<-SCRIPT
      export BUNDLE_GEMFILE="Gemfile"
      export RAILS_ENV="development"
      rm -f Gemfile.lock db/*.sqlite3
      bundle install
      #{command}
    SCRIPT
    Bundler.with_clean_env do
      Open3.capture3(script, :chdir => "example")
    end
  end
end
