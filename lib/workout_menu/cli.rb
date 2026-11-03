# frozen_string_literal: true

require "optparse"

module WorkoutMenu
  # コマンドライン入力を解釈して、メニューを出力する。
  class CLI
    DEFAULT_PLACE = "home"
    DEFAULT_COUNT = 4

    def self.run(argv, out: $stdout, err: $stderr)
      new(out: out, err: err).run(argv)
    end

    def initialize(out:, err:)
      @out = out
      @err = err
    end

    # 終了ステータスを返す(成功: 0、失敗: 1)。
    def run(argv)
      options = { place: DEFAULT_PLACE, count: DEFAULT_COUNT }
      parser = build_parser(options)
      parser.parse(argv)
      dispatch(options, parser)
      0
    rescue OptionParser::ParseError, Error => e
      @err.puts "workout_menu: #{e.message}"
      @err.puts "Try 'workout_menu --help' for usage."
      1
    end

    private

    def dispatch(options, parser)
      if options[:help]
        @out.puts parser.help
      elsif options[:version]
        @out.puts VERSION
      else
        print_menu(options)
      end
    end

    def build_parser(options)
      OptionParser.new do |parser|
        parser.banner = "Usage: workout_menu --part PART [options]"
        define_target_options(parser, options)
        define_amount_options(parser, options)
        define_info_options(parser, options)
      end
    end

    def define_target_options(parser, options)
      parts = Catalog::PARTS.keys
      places = Catalog::PLACES.keys
      parser.on("-p", "--part PART", parts.map(&:to_s), "鍛える部位 (#{parts.join(", ")})") { |v| options[:part] = v }
      parser.on("-l", "--place PLACE", places.map(&:to_s), "場所 (#{places.join(", ")}) 既定: #{DEFAULT_PLACE}") do |v|
        options[:place] = v
      end
    end

    def define_amount_options(parser, options)
      parser.on("-n", "--count N", Integer, "種目数 既定: #{DEFAULT_COUNT}") { |v| options[:count] = v }
      parser.on("-s", "--seed N", Integer, "乱数のシード(同じ値なら同じメニュー)") { |v| options[:seed] = v }
    end

    def define_info_options(parser, options)
      parser.on("-v", "--version", "バージョンを表示") { options[:version] = true }
      parser.on("-h", "--help", "ヘルプを表示") { options[:help] = true }
    end

    def print_menu(options)
      raise Error, "--part is required (#{Catalog::PARTS.keys.join(", ")})" unless options[:part]

      part = options[:part].to_sym
      place = options[:place].to_sym
      menu = Menu.new(random: random_for(options[:seed]))
      print_exercises(part, place, menu.suggest(part: part, place: place, count: options[:count]))
    end

    def random_for(seed)
      seed ? Random.new(seed) : Random.new
    end

    def print_exercises(part, place, exercises)
      @out.puts "今日のメニュー: #{Catalog::PARTS[part]} / #{Catalog::PLACES[place]}"
      exercises.each.with_index(1) { |e, i| @out.puts "#{i}. #{e.name}  #{e.volume}" }
    end
  end
end
