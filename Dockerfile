# Base image with Elixir, Erlang, Node.js, and Hex/Rebar installed
FROM hexpm/elixir:1.15.7-erlang-26.2.3-ubuntu-jammy as build

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    npm \
    curl \
    git \
    && apt-get clean

# Set working directory
WORKDIR /app

# Set environment variables
ENV MIX_ENV=prod

# Cache elixir deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod

# Copy the rest of the app and compile
COPY lib lib
COPY priv priv
COPY assets assets
RUN mix assets.deploy && \
    mix compile

# Build release
RUN mix release

# ------------------------
# Runtime stage
# ------------------------
FROM debian:bullseye-slim AS app

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    ncurses-bin \
    && apt-get clean

WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/kakwara_hospital ./

# Set environment variables
ENV MIX_ENV=prod \
    HOME=/app \
    PORT=10000

EXPOSE 10000

# Start app
CMD ["bin/kakwara_hospital", "start"]
