FROM hexpm/elixir:1.13.4-erlang-23.3.4.9-alpine-3.14.2 AS build

RUN apk update
RUN apk add --no-cache \
    build-base git python3 curl

# sets work dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get

# Set exposed ports
EXPOSE 4000
ENV PORT=4000

# copy compile configuration files
RUN mkdir config
COPY config/config.exs config/dev.exs config/

# compile dependencies
RUN mix deps.compile

# copy assets
COPY priv priv

# compile project
COPY lib lib
RUN mix compile

CMD ["mix", "run_dev"]