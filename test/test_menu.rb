# frozen_string_literal: true

require "test_helper"

class TestMenu < Minitest::Test
  def menu(seed: 1)
    WorkoutMenu::Menu.new(random: Random.new(seed))
  end

  def test_suggests_requested_number_of_exercises
    assert_equal 3, menu.suggest(part: :legs, place: :gym, count: 3).size
  end

  def test_has_no_duplicates
    exercises = menu.suggest(part: :legs, place: :gym, count: 6)

    assert_equal exercises.uniq, exercises
  end

  def test_only_suggests_matching_part_and_place
    exercises = menu.suggest(part: :back, place: :home, count: 10)

    assert(exercises.all? { |e| e.part == :back && e.places.include?(:home) })
  end

  def test_returns_all_when_count_exceeds_available
    available = WorkoutMenu::Catalog.load.select(part: :arms, place: :home).size

    assert_equal available, menu.suggest(part: :arms, place: :home, count: 100).size
  end

  def test_same_seed_gives_same_menu
    assert_equal menu(seed: 42).suggest(part: :chest, place: :gym),
                 menu(seed: 42).suggest(part: :chest, place: :gym)
  end

  def test_unknown_part_raises
    error = assert_raises(WorkoutMenu::Error) { menu.suggest(part: :neck, place: :home) }
    assert_match(/unknown part/, error.message)
  end

  def test_unknown_place_raises
    error = assert_raises(WorkoutMenu::Error) { menu.suggest(part: :chest, place: :moon) }
    assert_match(/unknown place/, error.message)
  end

  def test_non_positive_count_raises
    assert_raises(WorkoutMenu::Error) { menu.suggest(part: :chest, place: :home, count: 0) }
  end
end
