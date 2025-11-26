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

# 必須パッケージ + Node.js (for assets)
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      curl gnupg build-essential git libpq-dev pkg-config libvips libyaml-dev && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Gem install
COPY Gemfile Gemfile.lock ./
RUN bundle install

# full copy
COPY . .

# assets precompile (master.keyは不要)
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# --------------------------------------------------
# Final stage
# --------------------------------------------------
FROM base

# runtime に必要なパッケージのみ
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      libpq5 libvips libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

# copy from build stage
COPY --from=build /bundle /bundle
COPY --from=build /rails /rails

# pidsフォルダを作る
RUN mkdir -p /rails/tmp/pids


# user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER rails:rails

EXPOSE 3000

# Render 用（ENTRYPOINT は削除）
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
