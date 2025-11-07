source "https://rubygems.org"

ruby "3.2.9"

# Rails本体
gem "rails", "~> 7.1.5", ">= 7.1.5.2"

# アセットパイプライン
gem "sprockets-rails"

# データベース
gem "sqlite3", "1.6.9"

# Webサーバ
gem "puma", ">= 5.0"

# フロントエンド系
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# JSON API用
gem "jbuilder"

# Windows環境対応
gem "nokogiri", "~> 1.18.10", platforms: [:ruby, :x64_mingw, :windows]
gem "sassc-rails"
gem "tzinfo-data"

#ユーザー登録機能
gem 'devise'

#ページネーション
gem 'kaminari'





# 起動高速化
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
