defmodule Tictactoe.Bots do
  import Ecto.Query

  alias Tictactoe.{User, Game, Repo}

  alias Tictactoe.Interfaces.{
    UserEnters,
    GameInfo,
    UserMoves,
    UserChecksTheirGames,
    ShowLeaderBoard,
    UserCancelsGame
  }

  @sleep 1000
  @bot_x_name "FooBot"
  @bot_o_name "BarBot"

  def sleep, do: Process.sleep(@sleep)

  def run do
    delete_previous_data()
    script()
    run()
  end

  def delete_previous_data do
    from(g in Game,
      join: ux in User,
      on: ux.uuid == g.user_x_uuid,
      join: uo in User,
      on: uo.uuid == g.user_o_uuid,
      where: ux.name in [@bot_x_name, @bot_o_name] or uo.name in [@bot_x_name, @bot_o_name]
    )
    |> Repo.delete_all()

    from(u in User, where: u.name in [@bot_x_name, @bot_o_name])
    |> Repo.delete_all()
  end

  def user_enters(name, token) do
    {:ok, %{token: token, game: %{uuid: uuid}}} = UserEnters.call(name, token)
    {token, uuid}
  end

  def game_info(uuid) do
    GameInfo.call(uuid)
  end

  def user_moves(game_uuid, move, token) do
    UserMoves.call(game_uuid, move, token)
  end

  def user_checks_their_games(token) do
    UserChecksTheirGames.call(token)
  end

  def show_leader_board do
    ShowLeaderBoard.call()
  end

  def user_cancels_game(game_uuid, token) do
    UserCancelsGame.call(game_uuid, token)
  end

  # xox
  # xox
  # oxo
  def script do
    {token_x, game_uuid} = user_enters(@bot_x_name, nil)
    sleep()
    {token_o, ^game_uuid} = user_enters(@bot_o_name, nil)
    sleep()

    user_cancels_game("no_game", token_x)
    user_cancels_game("no_game", token_o)

    game_info(game_uuid)
    sleep()

    check_games(token_x, token_o)

    play_draw_game(game_uuid, token_x, token_o)

    check_games(token_x, token_o)
  end

  def check_games(token_x, token_o) do
    user_checks_their_games(token_x)
    sleep()

    user_checks_their_games(token_o)
    sleep()

    show_leader_board()
    sleep()

    show_leader_board()
    sleep()
  end

  def play_draw_game(game_uuid, token_x, token_o) do
    user_moves(game_uuid, 0, token_x)
    sleep()

    game_info(game_uuid)
    sleep()

    user_moves(game_uuid, 1, token_o)
    sleep()

    game_info(game_uuid)
    sleep()

    user_moves(game_uuid, 2, token_x)
    sleep()

    game_info(game_uuid)
    sleep()

    user_moves(game_uuid, 4, token_o)
    sleep()

    game_info(game_uuid)
    sleep()

    user_moves(game_uuid, 3, token_x)
    sleep()

    game_info(game_uuid)
    sleep()

    user_moves(game_uuid, 6, token_o)
    sleep()

    game_info(game_uuid)
    sleep()

    user_moves(game_uuid, 5, token_x)
    sleep()

    game_info(game_uuid)
    sleep()

    user_moves(game_uuid, 8, token_o)
    sleep()

    game_info(game_uuid)
    sleep()

    user_moves(game_uuid, 7, token_x)
    sleep()

    game_info(game_uuid)
    sleep()
  end
end
