# ALFMonitor

### Monitor your ALF application!

See:
- [Video](https://www.youtube.com/watch?v=8yqXyUR4hBA)
- [ALF — Flow-based Application Layer Framework](https://github.com/antonmi/alf)
- [TicTacToe example](https://github.com/antonmi/alf_monitor_tictactoe)


```sh
docker compose up
# or
docker compose up --build

# in other tab
docker compose watch
```

[![alt text](ALFMonitor.png "Monitor your ALF app")](https://www.youtube.com/watch?v=8yqXyUR4hBA)

localhost:4000 - Monitor

localhost:8080 - The game. Open in two browsers

### Issues
docker system prune --all --force --volumes

### Run without docker

```sh
# tictactoe backend
iex --sname tictactoe@localhost -S mix run --no-halt
# tictactoe fronted
npm run serve
# monitor
NODE=tictactoe@localhost iex --sname monitor@localhost -S mix phx.server
```

#### Notes
Simple websockets: https://medium.com/@loganbbres/elixir-websocket-chat-example-c72986ab5778