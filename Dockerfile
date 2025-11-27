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

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# --------------------------------------------------
# Final stage
# --------------------------------------------------
FROM base

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      libpq5 libvips libyaml-dev postgresql-client && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /bundle /bundle
COPY --from=build /rails /rails

RUN mkdir -p /rails/tmp/pids \
 && rm -f /rails/tmp/pids/server.pid

COPY bin/docker-entrypoint /usr/bin/docker-entrypoint
RUN chmod +x /usr/bin/docker-entrypoint

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER rails:rails

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint"]

# Rails 起動コマンドだけ書く
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
