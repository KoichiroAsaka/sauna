# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.9
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_PATH=/bundle

# --------------------------------------------------
# Build stage
# --------------------------------------------------
FROM base AS build

# Node.js + Yarn を公式リポジトリからインストール
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libpq-dev \
      pkg-config \
      libvips

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# --------------------------------------------------
# Final stage
# --------------------------------------------------
FROM base

# Node.js + Yarn（実行用）
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    apt-get install -y --no-install-recommends \
      libpq5 \
      libvips && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /bundle /bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
