defmodule Tictactoe.Pipelines.UserChecksTheirGames do
  use ALF.DSL

  alias Tictactoe.{Games, Game, Users, User}

  defstruct token: nil,
            user: nil,
            games: [],
            opponents: [],
            games_list: [],
            error: nil

  @type t :: %__MODULE__{
          token: String.t(),
          user: User.t(),
          games: list(Game.t()),
          opponents: %{String.t() => User.t()},
          games_list: list(),
          error: nil | :game_is_not_active
        }

  @components [
    stage(:validate_input),
    done(:done_if_invalid_input),
    stage(:find_user_by_token),
    stage(:find_games),
    stage(:preload_opponents),
    stage(:format_games_list)
  ]

  def validate_input(%__MODULE__{} = event, _) do
    if event.token do
      event
    else
      %{event | error: :invalid_input}
    end
  end

  def done_if_invalid_input(%__MODULE__{error: nil}, _), do: false
  def done_if_invalid_input(%__MODULE__{error: :invalid_input}, _), do: true

  def find_user_by_token(%__MODULE__{token: token} = event, _) do
    case Users.find(token) do
      %User{} = user ->
        %{event | user: user}

      nil ->
        %{event | error: :no_such_user}
    end
  end

  def done_if_no_user(%__MODULE__{error: :no_such_user}, _), do: true
  def done_if_no_user(%__MODULE__{error: nil}, _), do: false

  def find_games(%__MODULE__{user: user} = event, _) do
    games = Games.games_for_user(user.uuid)
    %{event | games: games}
  end

  def preload_opponents(%__MODULE__{games: games} = event, _) do
    opponents =
      games
      |> Enum.map(&[&1.user_x_uuid, &1.user_o_uuid])
      |> List.flatten()
      |> Users.users_for_uuids()
      |> Enum.map(&{&1.uuid, &1})
      |> Enum.into(%{})

    %{event | opponents: opponents}
  end

  def format_games_list(%__MODULE__{user: user, games: games, opponents: opponents} = event, _) do
    games_list =
      games
      |> Enum.map(fn game ->
        %{
          uuid: game.uuid,
          field: game.field,
          status: game.status,
          turn_uuid: game.turn_uuid,
          opponent_name: opponent_for_user(game, user, opponents)
        }
      end)

    %{event | games_list: games_list}
  end

  defp opponent_for_user(game, user, opponents) do
    if game.user_x_uuid == user.uuid do
      Map.get(opponents, game.user_o_uuid, nil)
    else
      Map.get(opponents, game.user_x_uuid, nil)
    end
    |> fetch_name()
  end

  defp fetch_name(nil), do: nil
  defp fetch_name(user), do: user.name
end
