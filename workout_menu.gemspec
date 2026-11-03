# frozen_string_literal: true

require_relative "lib/workout_menu/version"

Gem::Specification.new do |spec|
  spec.name = "workout_menu"
  spec.version = WorkoutMenu::VERSION
  spec.authors = ["T-REX1996"]
  spec.email = ["bump12@icloud.com"]

  spec.summary = "A command-line tool that suggests a workout menu for your training day."
  spec.description = "workout_menu suggests a workout menu by body part and place, " \
                     "so you can decide what to train without thinking."
  spec.homepage = "https://github.com/T-REX1996/workout_menu"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://guides.rubygems.org/make-your-own-gem/
end
