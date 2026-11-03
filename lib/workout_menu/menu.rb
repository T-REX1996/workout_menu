# frozen_string_literal: true

module WorkoutMenu
  # 部位と場所からトレーニングメニューを提案する。
  class Menu
    def initialize(catalog: Catalog.load, random: Random.new)
      @catalog = catalog
      @random = random
    end

    # 条件に合う種目を、重複なしでランダムに count 個まで選ぶ。
    def suggest(part:, place:, count: 4)
      validate!(part, place, count)
      @catalog.select(part: part, place: place).sample(count, random: @random)
    end

    private

    def validate!(part, place, count)
      raise Error, "unknown part: #{part}" unless Catalog::PARTS.key?(part)
      raise Error, "unknown place: #{place}" unless Catalog::PLACES.key?(place)
      raise Error, "count must be positive: #{count}" unless count.positive?
    end
  end
end
