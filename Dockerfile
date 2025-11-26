# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.9
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# --------------------------------------------------
# Build stage
# --------------------------------------------------
FROM base as build

# 必要なビルド系パッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git libvips pkg-config libpq-dev nodejs

# Gem のインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# アプリコードをコピー
COPY . .

# bootsnap のプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# bin を Linux 用に整形
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Assets precompile（MASTER_KEY 不要）
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# --------------------------------------------------
# Final stage
# --------------------------------------------------
FROM base

# Deploy に必要なランタイムパッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libsqlite3-0 libvips libpq5 nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
