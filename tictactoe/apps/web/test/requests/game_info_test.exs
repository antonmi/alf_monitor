defmodule Web.Requests.GameInfoTest do
  use Tictactoe.DataCase
  use Plug.Test

  def post_user_enters(name, params \\ %{}) do
    :post
    |> conn("/user_enters/#{name}", params)
    |> Web.Router.call(%{})
  end

  def get_game_info(uuid) do
    :get
    |> conn("/game_info/#{uuid}")
    |> Web.Router.call(%{})
  end

  setup do
    conn = post_user_enters("anton")
    data = Jason.decode!(conn.resp_body)

    uuid = data["game"]["uuid"]
    %{uuid: uuid}
  end

  test "success case", %{uuid: uuid} do
    conn = get_game_info(uuid)
    data = Jason.decode!(conn.resp_body)

    assert %{
             "game" => %{
               "field" => [nil, nil, nil, nil, nil, nil, nil, nil, nil],
               "status" => "pending",
               "turn_uuid" => uuid,
               "uuid" => _game_uuid
             },
             "user_o" => %{},
             "user_x" => %{
               "name" => "anton",
               "uuid" => uuid
             }
           } = data
  end

  test "not found" do
    conn = get_game_info("110011e1-f4af-438b-968a-df325eeae56e")
    data = Jason.decode!(conn.resp_body)

    assert %{"error" => "no_such_game"} = data
  end

  test "with invalid_uuid" do
    conn = get_game_info("invalid_uuid")
    data = Jason.decode!(conn.resp_body)

    assert %{"error" => "no_such_game"} = data
  end
end
