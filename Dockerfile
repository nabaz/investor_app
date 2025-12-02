FROM elixir:1.18-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git build-base bash

# Copy mix files
COPY mix.exs mix.lock ./

# Install Elixir dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Copy source code
COPY lib ./lib
COPY priv ./priv
COPY config ./config
COPY assets ./assets

# Expose port
EXPOSE 4001

# Start application
CMD ["mix", "phx.server"]
