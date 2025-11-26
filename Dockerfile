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

# Node.js + Yarn + 必須パッケージ
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      curl gnupg build-essential git libpq-dev pkg-config libvips libyaml-dev && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# master.key 不要で precompile
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# --------------------------------------------------
# Final stage
# --------------------------------------------------
FROM base

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      curl gnupg libpq5 libvips libyaml-dev && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /bundle /bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
