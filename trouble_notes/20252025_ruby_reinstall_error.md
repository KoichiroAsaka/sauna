# 🧰 Rails開発環境トラブル対応まとめ（Ruby再インストール編）

## ■ 発生状況
Railsコントローラを作成・実行しようとした際に、以下のようなエラーが発生し、アプリが正常に動作しなかった。

```
sqlite3 version mismatch
or
cannot load such file -- sqlite3
or
rails command not found
```

または、Railsサーバー実行時に
`Gem::Ext::BuildError`, `LoadError`, `ruby.exeが見つからない` 等のエラーが出る。

---

## ■ 原因

| 原因 | 詳細説明 |
|------|-----------|
| **1. Rubyのバージョン不整合** | Rubyを複数バージョン（例：3.1系と3.2系）でインストールしており、Railsが古いRubyを参照していた。 |
| **2. PATH設定の競合** | Windows環境で複数のRubyパスが通っており、`where ruby`で複数パス（例：C:\Ruby31-x64, C:\Ruby32-x64）が表示された。 |
| **3. Gem依存関係の破損** | Rubyを再インストールする過程でgemフォルダが不整合を起こし、sqlite3やrailsのgemが動作しなかった。 |
| **4. Bundler環境のずれ** | `Gemfile.lock` のRubyバージョン指定と実際のRuby環境が合っていなかった。 |

---

## ■ 対策手順

### ✅ 1. Rubyのクリーン再インストール
1. 既存のRubyフォルダを削除（例：`C:\Ruby31-x64` など）  
2. [公式Rubyサイト](https://rubyinstaller.org/downloads/) から最新版を再インストール  
3. インストール後、以下でバージョン確認：
   ```bash
   ruby -v
   rails -v
   ```

---

### ✅ 2. PATH設定を整理
以下のコマンドで複数のRubyが存在しないか確認：

```bash
where ruby
where rails
```

結果が1行だけになるように調整（不要なパスは環境変数から削除）。

---

### ✅ 3. BundlerとGemを再構築
```bash
gem install bundler
bundle install
```

必要に応じて：
```bash
gem uninstall sqlite3
gem install sqlite3
```

---

### ✅ 4. Rails環境の再確認
```bash
rails s
```

が正常に動けばOK。  
また、DB関連のマイグレーションが必要な場合は：

```bash
rails db:drop db:create db:migrate
```

を再実行。

---

## ■ 補足：確認に使った主なコマンド

| コマンド | 内容 |
|-----------|------|
| `where ruby` | Rubyの実行パスを確認 |
| `ruby -v` | 現在使用中のRubyバージョンを確認 |
| `rails -v` | Railsのバージョンを確認 |
| `gem list` | インストール済みGemを一覧表示 |
| `bundle install` | Gemfileに基づき依存関係を再構築 |

---

## ■ 今回の学び

- Rubyを複数インストールすると、PATH競合でRailsが動かなくなる。  
- `where ruby` と `ruby -v` を確認することで、どのRubyが使われているかを特定できる。  
- 不具合時は「再インストール + 環境変数整理 + bundle再構築」が最も確実なリセット手段。
