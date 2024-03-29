require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @config = GoodMigrations::Configuration.new
  end

  def test_permit_autoloading_before_set_nil
    @config.permit_autoloading_before = nil

    assert_nil @config.permit_autoloading_before
  end

  def test_permit_autoloading_before_set_string
    @config.permit_autoloading_before = "20210203"
    assert_equal Time.new(2021, 2, 3), @config.permit_autoloading_before

    @config.permit_autoloading_before = "20210203101112"
    assert_equal Time.new(2021, 2, 3, 10, 11, 12), @config.permit_autoloading_before

    @config.permit_autoloading_before = "20210203_121112"
    assert_equal Time.new(2021, 2, 3, 12, 11, 12), @config.permit_autoloading_before

    @config.permit_autoloading_before = "2021-04-03 12:11:12"
    assert_equal Time.new(2021, 4, 3, 12, 11, 12), @config.permit_autoloading_before
  end

  def test_permit_autoloading_before_set_bad_string
    assert_raises(ArgumentError) do
      @config.permit_autoloading_before = "abc"
    end
  end

  def test_permit_autoloading_before_set_date
    @config.permit_autoloading_before = Date.new(2021, 4, 15)

    assert_equal Time.new(2021, 4, 15), @config.permit_autoloading_before
  end

  def test_permit_autoloading_before_set_time
    @config.permit_autoloading_before = Time.new(2021, 4, 20, 16, 17, 18)

    assert_equal Time.new(2021, 4, 20, 16, 17, 18), @config.permit_autoloading_before
  end
end
