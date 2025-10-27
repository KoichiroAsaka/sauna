# Saunaモデルのエラー原因と対策まとめ

## 発生したエラー
Railsコンソールで `Sauna.class` を確認した際に、以下のように出力された。

```ruby
Sauna.class
=> Module
```

## 原因
`config/application.rb` 内でアプリケーションのモジュール名が `module Sauna` になっていたため、
Railsは「Sauna」という**アプリケーションモジュール**を定義してしまい、
同名の **モデルクラス（app/models/sauna.rb）** と名前が衝突していた。

その結果、Rubyは `Sauna` をクラスではなくモジュールとして認識していた。

### 該当箇所（誤り）
```ruby
module Sauna
  class Application < Rails::Application
```

## 対策
アプリケーションモジュール名を他の名前（例：`SaunaApp`）に変更することで解決。

### 修正後
```ruby
module SaunaApp
  class Application < Rails::Application
```

この修正後、以下を実行して確認：

```bash
rails zeitwerk:check
```

結果：

```
All is good!
```

その後、Railsコンソールで再確認：

```ruby
Sauna.class
=> Class
```

正常に `Sauna` モデルが認識されるようになった。

## 教訓
- Railsのアプリケーション名とモデル名を**同一にしない**  
  → 名前衝突により、意図したクラスが認識されない可能性がある。

- モジュール名の変更後は `rails zeitwerk:check` で自動読み込みが正常に動作しているか確認する。
