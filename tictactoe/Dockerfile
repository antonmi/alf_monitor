FROM elixir:1.15.7-alpine as build

COPY . .

RUN apk add --no-cache --upgrade bash

RUN mix local.hex --force && mix deps.get && mix compile

EXPOSE 4001
