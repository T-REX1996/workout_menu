# frozen_string_literal: true

require "yaml"

module WorkoutMenu
  # 種目データの読み込みと絞り込みを担当する。
  class Catalog
    PARTS = {
      chest: "胸",
      back: "背中",
      legs: "脚",
      shoulders: "肩",
      arms: "腕",
      abs: "腹筋"
    }.freeze

    PLACES = {
      home: "自宅",
      gym: "ジム"
    }.freeze

    DEFAULT_PATH = File.expand_path("exercises.yml", __dir__)
    DEFAULT_UNIT = "回"

    def self.load(path = DEFAULT_PATH)
      data = YAML.safe_load_file(path, symbolize_names: true)
      new(data.fetch(:exercises).map { |attrs| build_exercise(attrs) })
    end

    def self.build_exercise(attrs)
      Exercise.new(unit: DEFAULT_UNIT, **attrs, part: attrs[:part].to_sym, places: attrs[:places].map(&:to_sym))
    end
    private_class_method :build_exercise

    def initialize(exercises)
      @exercises = exercises.freeze
    end

    attr_reader :exercises

    def select(part:, place:)
      exercises.select { |e| e.part == part && e.places.include?(place) }
    end
  end
end
