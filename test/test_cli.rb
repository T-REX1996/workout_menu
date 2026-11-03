# frozen_string_literal: true

require "test_helper"
require "stringio"

class TestCLI < Minitest::Test
  def run_cli(*argv)
    out = StringIO.new
    err = StringIO.new
    status = WorkoutMenu::CLI.run(argv, out: out, err: err)
    [status, out.string, err.string]
  end

  def test_prints_menu_with_header
    status, out, err = run_cli("--part", "chest", "--place", "home", "--seed", "1")

    assert_equal 0, status
    assert_empty err
    assert_includes out, "今日のメニュー: 胸 / 自宅"
    assert_match(/^1\. .+  3セット × \d+(回|秒)$/, out)
  end

  def test_defaults_to_home_and_four_exercises
    _status, out, _err = run_cli("-p", "legs", "-s", "1")

    assert_includes out, "脚 / 自宅"
    assert_equal 4, out.lines.grep(/^\d+\. /).size
  end

  def test_count_option
    _status, out, _err = run_cli("-p", "abs", "-n", "2", "-s", "1")

    assert_equal 2, out.lines.grep(/^\d+\. /).size
  end

  def test_same_seed_gives_same_output
    assert_equal run_cli("-p", "back", "-l", "gym", "-s", "7"),
                 run_cli("-p", "back", "-l", "gym", "-s", "7")
  end

  def test_missing_part_fails
    status, out, err = run_cli

    assert_equal 1, status
    assert_empty out
    assert_includes err, "--part is required"
  end

  def test_invalid_part_fails
    status, _out, err = run_cli("--part", "neck")

    assert_equal 1, status
    assert_includes err, "invalid argument"
  end

  def test_invalid_option_fails
    status, _out, err = run_cli("--unknown")

    assert_equal 1, status
    assert_includes err, "invalid option"
  end

  def test_non_positive_count_fails
    status, _out, err = run_cli("-p", "chest", "-n", "0")

    assert_equal 1, status
    assert_includes err, "count must be positive"
  end

  def test_version
    status, out, = run_cli("--version")

    assert_equal 0, status
    assert_equal "#{WorkoutMenu::VERSION}\n", out
  end

  def test_help
    status, out, = run_cli("--help")

    assert_equal 0, status
    assert_includes out, "Usage: workout_menu"
  end
end
