# Base image with Elixir and Erlang
FROM hexpm/elixir:1.15.7-erlang-26.2.3-alpine as build

# Install OS dependencies
RUN apk add --no-cache build-base npm git

# Set working directory
WORKDIR /app

# Set environment
ENV MIX_ENV=prod

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Cache deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod

# Copy source files
COPY lib lib
COPY priv priv
COPY assets assets

# Build and compile assets
RUN mix assets.deploy && \
    mix compile && \
    mix release

# Runtime stage
FROM alpine:3.18 AS app

RUN apk add --no-cache libssl1.1 ncurses

WORKDIR /app
COPY --from=build /app/_build/prod/rel/kakwara_hospital ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV PORT=10000

EXPOSE 10000
CMD ["bin/kakwara_hospital", "start"]
