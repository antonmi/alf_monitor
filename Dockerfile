FROM elixir:1.15.7-alpine as build

COPY . .

RUN apk update
RUN apk add inotify-tools make build-base musl-dev git nodejs npm

RUN cd assets && npm install
RUN mix local.hex --force && mix deps.get && mix compile

EXPOSE 4001
