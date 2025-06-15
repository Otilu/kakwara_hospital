# Base image with Elixir, Erlang, Node.js, and Hex/Rebar installed
FROM hexpm/elixir:1.15.7-erlang-26.2.3-ubuntu-jammy-20230925 as build

# Install dependencies
RUN apt-get update && apt-get install -y build-essential npm curl git

# Set workdir
WORKDIR /app

# Copy mix files and install deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix local.hex --force && \
    mix local.rebar --force && \
    MIX_ENV=prod mix deps.get

# Copy app code and compile
COPY lib lib
COPY priv priv
COPY assets assets
RUN MIX_ENV=prod mix assets.deploy && \
    MIX_ENV=prod mix compile

# Build the release
RUN MIX_ENV=prod mix release

# Runtime image
FROM debian:bullseye-slim AS app
RUN apt-get update && apt-get install -y libssl-dev ncurses-bin && apt-get clean

WORKDIR /app
COPY --from=build /app/_build/prod/rel/kakwara_hospital ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV PORT=10000

CMD ["bin/kakwara_hospital", "start"]
