# frozen_string_literal: true

module WorkoutMenu
  # 1つのトレーニング種目。
  Exercise = Data.define(:name, :part, :places, :sets, :reps, :unit) do
    # 例: "3セット × 15回"
    def volume
      "#{sets}セット × #{reps}#{unit}"
    end
  end
end
