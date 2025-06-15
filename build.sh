#!/usr/bin/env bash

set -o errexit

# Get deps
mix deps.get --only prod
MIX_ENV=prod mix compile

# Assets
npm install --prefix assets
npm run deploy --prefix assets
mix phx.digest

# DB migrate
MIX_ENV=prod mix ecto.migrate

# Build release
MIX_ENV=prod mix release
