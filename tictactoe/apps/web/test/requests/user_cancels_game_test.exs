defmodule Web.Requests.UserCancelsGameTest do
  use Tictactoe.DataCase
  use Plug.Test

  def cancel_game(uuid, token) do
    :post
    |> conn("/user_cancels_game/#{uuid}", %{token: token})
    |> Web.Router.call(%{})
  end

  def post_user_enters(name, params \\ %{}) do
    conn =
      :post
      |> conn("/user_enters/#{name}", params)
      |> Web.Router.call(%{})

    data = Jason.decode!(conn.resp_body)
    {data["token"], data["game"]["uuid"]}
  end

  setup do
    {anton_token, game_uuid} = post_user_enters("anton")
    {baton_token, ^game_uuid} = post_user_enters("baton")
    %{anton_token: anton_token, baton_token: baton_token, game_uuid: game_uuid}
  end

  test "anton cancels the game", %{anton_token: anton_token, game_uuid: game_uuid} do
    conn = cancel_game(game_uuid, anton_token)
    data = Jason.decode!(conn.resp_body)
    assert data["game"]["status"] == "cancelled"
  end
end
