defmodule Web.Requests.ShowLeaderBoardTest do
  use Tictactoe.DataCase
  use Plug.Test

  def show_board() do
    :get
    |> conn("/show_leader_board")
    |> Web.Router.call(%{})
  end

  def post_user_enters(name, params \\ %{}) do
    conn =
      :post
      |> conn("/user_enters/#{name}", params)
      |> Web.Router.call(%{})

    data = Jason.decode!(conn.resp_body)
    data["token"]
  end

  setup do
    token = post_user_enters("anton")
    %{token: token}
  end

  test "check board" do
    conn = show_board()
    data = Jason.decode!(conn.resp_body)
    assert [%{"name" => "anton", "scores" => 0}] = data
  end
end
