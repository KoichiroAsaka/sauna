# SQLite3 gem エラー原因と対策（Railsアプリ共通）

## 🔧 発生状況

Railsアプリ開発中に、`rails db:migrate` または `rails s`
実行時に、SQLite3関連のエラーが頻発。\
例：

    LoadError: Error loading the 'sqlite3' Active Record adapter.
    Could not load 'sqlite3' gem.

または

    cannot load such file -- sqlite3

------------------------------------------------------------------------

## 💡 主な原因

  ----------------------------------------------------------------------------------------------------------------------
  分類               原因内容                             詳細
  ------------------ ------------------------------------ --------------------------------------------------------------
  gem依存関係        RubyやRailsのバージョンと`sqlite3`   新しいRailsバージョンで古いsqlite3を参照しているケースが多い
                     gemの互換性が崩れる                  

  インストール環境   Windows環境特有のビルドエラー        `sqlite3.h` が存在しない、DLL不足など

  Gemfile不整合      `bundle install`                     Gemfile.lockが壊れている可能性
                     時に異なるgemが再解決                

  DBファイル         `db/development.sqlite3`             migration失敗時に発生する
                     のロックまたは破損                   
  ----------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

## 🧰 対応策（手順順に実施）

### ① Gemfileを明示的に修正

``` ruby
# Gemfile
gem "sqlite3", "~> 1.6"
```

> ※Rails 7系や8系では 1.6.x が安定。

------------------------------------------------------------------------

### ② 一度クリーンインストール

``` bash
bundle install --path vendor/bundle
bundle update sqlite3
```

もしそれでも動かない場合：

``` bash
gem uninstall sqlite3
gem install sqlite3
```

------------------------------------------------------------------------

### ③ DBファイルのリセット

DBが壊れている可能性もあるため、以下で再作成：

``` bash
rails db:drop
rails db:create
rails db:migrate
```

------------------------------------------------------------------------

### ④ Rubyとgem環境の再構築（最終手段）

それでも解消しない場合、Ruby環境そのものを再インストール：

``` bash
gem uninstall bundler
gem uninstall sqlite3
ridk install     # ※Windowsの場合
gem install bundler
bundle install
```

------------------------------------------------------------------------

## ✅ 再発防止メモ

-   `bundle install` 前に Gemfile.lock
    を削除しておくと依存の再解決がスムーズ。\
-   RubyやRailsのバージョン変更時は必ず `sqlite3`
    の対応バージョンを確認。\
-   Windows環境では `ridk install` でMSYS2を更新しておくこと。\
-   環境を安定させたい場合は、`MySQL` や `PostgreSQL`
    への切り替えも検討。

------------------------------------------------------------------------

## 📘 まとめ

  問題                    対策
  ----------------------- --------------------------------------
  gemのバージョン不一致   Gemfileでバージョンを固定する
  SQLiteビルドエラー      `ridk install` を実行
  DB破損                  `rails db:drop db:create db:migrate`
  環境依存エラー          Rubyを再インストール
