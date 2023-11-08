defmodule Tictactoe.EventPoolTest do
  use Tictactoe.DataCase

  alias Tictactoe.EventPool

  alias Tictactoe.Pipelines.UserEnters

  setup do
    UserEnters.start()
    on_exit(&UserEnters.stop/0)
  end

  test "user_enters event" do
    {:ok, event} = EventPool.process_event(%UserEnters{username: "anton"})

    assert %UserEnters{username: "anton", error: nil} = event
  end
end
