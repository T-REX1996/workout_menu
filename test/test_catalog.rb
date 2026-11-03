# frozen_string_literal: true

require "test_helper"

class TestCatalog < Minitest::Test
  def setup
    @catalog = WorkoutMenu::Catalog.load
  end

  def test_loads_exercises
    refute_empty @catalog.exercises
    assert_kind_of WorkoutMenu::Exercise, @catalog.exercises.first
  end

  def test_all_exercises_use_known_parts_and_places
    @catalog.exercises.each do |e|
      assert WorkoutMenu::Catalog::PARTS.key?(e.part), "#{e.name}: unknown part #{e.part}"
      refute_empty e.places, "#{e.name}: places is empty"
      e.places.each do |place|
        assert WorkoutMenu::Catalog::PLACES.key?(place), "#{e.name}: unknown place #{place}"
      end
    end
  end

  def test_exercise_names_are_unique_per_part
    names = @catalog.exercises.map { |e| [e.part, e.name] }
    assert_equal names.uniq, names
  end

  def test_every_part_and_place_has_exercises
    WorkoutMenu::Catalog::PARTS.each_key do |part|
      WorkoutMenu::Catalog::PLACES.each_key do |place|
        refute_empty @catalog.select(part: part, place: place), "no exercises for #{part} / #{place}"
      end
    end
  end

  def test_select_filters_by_part_and_place
    selected = @catalog.select(part: :chest, place: :home)

    assert(selected.all? { |e| e.part == :chest && e.places.include?(:home) })
    assert_includes selected.map(&:name), "腕立て伏せ"
    refute_includes selected.map(&:name), "ベンチプレス"
  end

  def test_unit_defaults_to_times_when_omitted_in_data
    pushup = @catalog.exercises.find { |e| e.name == "腕立て伏せ" }

    assert_equal "回", pushup.unit
    assert_equal "3セット × 15回", pushup.volume
  end

  def test_unit_can_be_overridden_in_data
    plank = @catalog.exercises.find { |e| e.name == "プランク" }

    assert_equal "3セット × 45秒", plank.volume
  end
end
