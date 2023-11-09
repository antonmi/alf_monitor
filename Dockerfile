FROM elixir:1.15.7-alpine as build

COPY _build _build
COPY assets assets
COPY config config
COPY deps deps
COPY lib lib
COPY priv priv
COPY mix.exs mix.exs
COPY mix.lock mix.lock

RUN apk update
RUN apk add inotify-tools make nodejs npm

RUN cd assets && npm install
RUN mix local.hex --force && mix deps.get && mix compile

EXPOSE 4001
