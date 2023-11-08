defmodule Web.Requests.UserMovesTest do
  use Tictactoe.DataCase
  use Plug.Test

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

  test "user moves", %{anton_token: anton_token, baton_token: baton_token, game_uuid: game_uuid} do
    conn =
      :post
      |> conn("/user_moves/#{game_uuid}/4", %{token: anton_token})
      |> Web.Router.call(%{})

    data = Jason.decode!(conn.resp_body)

    assert %{
             "game" => %{
               "field" => [nil, nil, nil, nil, 1, nil, nil, nil, nil],
               "status" => "active",
               "turn_uuid" => ^baton_token,
               "uuid" => ^game_uuid
             },
             "user_o" => %{
               "name" => "baton",
               "uuid" => ^baton_token
             },
             "user_x" => %{
               "name" => "anton",
               "uuid" => ^anton_token
             }
           } = data
  end
end
