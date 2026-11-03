# WorkoutMenu

「今日、何を鍛えよう?」と迷う時間をなくす、筋トレメニュー提案コマンドです。
鍛えたい部位と場所を指定すると、ランダムに種目を選んで、セット数と回数つきで表示します。

```console
$ workout_menu --part chest --place home
今日のメニュー: 胸 / 自宅
1. ワイドプッシュアップ  3セット × 12回
2. 腕立て伏せ  3セット × 15回
3. デクラインプッシュアップ  3セット × 12回
4. インクラインプッシュアップ  3セット × 15回
```

## Installation

```bash
gem install workout_menu
```

Bundler を使う場合は、Gemfile に次の行を追加します。

```ruby
gem "workout_menu"
```

Ruby 3.2 以上が必要です。

## Usage

```console
$ workout_menu --part PART [options]
```

| オプション | 説明 | 既定値 |
|---|---|---|
| `-p`, `--part PART` | 鍛える部位(**必須**) | - |
| `-l`, `--place PLACE` | 場所 | `home` |
| `-n`, `--count N` | 種目数 | `4` |
| `-s`, `--seed N` | 乱数のシード。同じ値なら同じメニューになる | ランダム |
| `-v`, `--version` | バージョンを表示 | - |
| `-h`, `--help` | ヘルプを表示 | - |

### 部位 (`--part`)

| 値 | 部位 |
|---|---|
| `chest` | 胸 |
| `back` | 背中 |
| `legs` | 脚 |
| `shoulders` | 肩 |
| `arms` | 腕 |
| `abs` | 腹筋 |

### 場所 (`--place`)

| 値 | 内容 |
|---|---|
| `home` | 自宅。器具を使わない種目だけを提案する |
| `gym` | ジム。マシンやバーベルを使う種目も提案する |

### 例

```console
# ジムで脚を鍛える(種目数は 5)
$ workout_menu -p legs -l gym -n 5

# 同じシードなら、いつも同じメニューになる
$ workout_menu -p back -s 42
```

時間で行う種目(プランクなど)は、回数ではなく秒数で表示されます。

```console
$ workout_menu -p abs -l gym -n 3 -s 2
今日のメニュー: 腹筋 / ジム
1. ケーブルクランチ  3セット × 15回
2. ハンギングレッグレイズ  3セット × 10回
3. マウンテンクライマー  3セット × 30秒
```

### エラー

指定が正しくないときは、メッセージを標準エラー出力に出して、終了ステータス 1 で終了します。

```console
$ workout_menu
workout_menu: --part is required (chest, back, legs, shoulders, arms, abs)
Try 'workout_menu --help' for usage.
```

### Ruby から使う

```ruby
require "workout_menu"

menu = WorkoutMenu::Menu.new
menu.suggest(part: :chest, place: :home, count: 3).each do |exercise|
  puts "#{exercise.name} #{exercise.volume}"
end
```

## 種目を追加・変更するには

種目は [`lib/workout_menu/exercises.yml`](lib/workout_menu/exercises.yml) に定義されています。
次の形式で追記すると、提案の対象になります。

```yaml
- { name: 腕立て伏せ, part: chest, places: [home, gym], sets: 3, reps: 15 }
```

時間で行う種目は、`unit: 秒` を加えます。

## Development

リポジトリを clone したあと、`bin/setup` で依存をインストールします。
`bundle exec rake` で、テストと RuboCop を実行します。`bin/console` で、対話的に試せます。

```bash
bin/setup
bundle exec rake
bundle exec exe/workout_menu --part chest
```

このgemをローカルにインストールするには `bundle exec rake install` を実行します。
新しいバージョンをリリースするには、`lib/workout_menu/version.rb` のバージョンを更新して、`bundle exec rake release` を実行します。
gitタグの作成、コミットとタグの push、`.gem` ファイルの [rubygems.org](https://rubygems.org) への公開が行われます。

## Contributing

バグ報告やプルリクエストは、GitHub の https://github.com/T-REX1996/workout_menu で歓迎します。

## License

このgemは、[MIT License](https://opensource.org/licenses/MIT) の条件のもとでオープンソースとして公開されています。
