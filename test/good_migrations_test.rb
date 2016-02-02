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
    stdout, stderr, status = shell("bundle exec rake db:drop db:create db:migrate VERSION=20160202162849")

    assert_equal 0, status
  end

  def test_rake_full_migrate_blows_up
    stdout, stderr, status = shell("bundle exec rake db:drop db:create db:migrate")

    refute_equal 0, status
    assert_match /GoodMigrations::LoadError: Did you reference 'Pant'/, stderr
  end

  def test_env_flag_prevents_explosion
    stdout, stderr, status = shell("BAD_MIGRATIONS=true bundle exec rake db:drop db:create db:migrate")

    assert_equal 0, status
  end

private

  def shell(command)
    script = <<-SCRIPT
      export BUNDLE_GEMFILE="Gemfile"
      rm -f Gemfile.lock
      bundle install
      #{command}
    SCRIPT
    Open3.capture3(script, :chdir => "example")
  end
end
