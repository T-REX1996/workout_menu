# frozen_string_literal: true

require_relative "workout_menu/version"

module WorkoutMenu
  class Error < StandardError; end
end

require_relative "workout_menu/exercise"
require_relative "workout_menu/catalog"
require_relative "workout_menu/menu"
require_relative "workout_menu/cli"
