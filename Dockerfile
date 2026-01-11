FROM ruby:3.2.8-slim AS base

WORKDIR /app

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle config without development && \
    bundle install  && \
    rm -rf ~/.bundle/ "/usr/local/bundle"/ruby/*/cache "$/usr/local/bundle"/ruby/*/bundler/gems/*/.git
COPY . .

FROM base

# # Copy built artifacts: gems, application
COPY --from=build "/usr/local/bundle" "/usr/local/bundle"
COPY --from=build /app /app

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 ruby && \
    useradd ruby --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

CMD ["ruby", "main.rb"]