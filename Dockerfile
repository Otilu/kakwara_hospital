# Base image with Elixir and Erlang installed
FROM hexpm/elixir:1.15.7-erlang-26.2.3 as build

# Install build dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  npm \
  git \
  curl \
  && apt-get clean

WORKDIR /app

# Set environment
ENV MIX_ENV=prod

# Install Hex and Rebar
RUN mix local.hex --force && mix local.rebar --force

# Install dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod

# Copy source and build
COPY lib lib
COPY priv priv
COPY assets assets
RUN mix assets.deploy && mix compile && mix release

# Runtime image
FROM debian:bullseye-slim AS app
RUN apt-get update && apt-get install -y libssl-dev ncurses-bin && apt-get clean

WORKDIR /app
COPY --from=build /app/_build/prod/rel/kakwara_hospital ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV PORT=10000

EXPOSE 10000
CMD ["bin/kakwara_hospital", "start"]
