defmodule Web.Requests.UserChecksTheirGamesTest do
  use Tictactoe.DataCase
  use Plug.Test

  def check_games(token) do
    :post
    |> conn("/user_checks_their_games", %{token: token})
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

  test "check games", %{token: token} do
    conn = check_games(token)
    data = Jason.decode!(conn.resp_body)

    assert [
             %{
               "field" => [nil, nil, nil, nil, nil, nil, nil, nil, nil],
               "opponent_name" => nil,
               "status" => "pending",
               "turn_uuid" => _turn_uuid,
               "uuid" => _uuid
             }
           ] = data
  end
end
