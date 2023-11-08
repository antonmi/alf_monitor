defmodule Tictactoe.Pipelines.UserEnters do
  use ALF.DSL

  alias Tictactoe.{Games, Game, Users, User}

  defstruct username: "",
            token: nil,
            users_with_the_name: [],
            user: nil,
            game: nil,
            game_data: %{},
            error: nil

  @type t :: %__MODULE__{
          username: String.t(),
          token: String.t(),
          users_with_the_name: list(User.t()),
          user: User.t(),
          game: Game.t(),
          game_data: map,
          error: nil | :invalid_input | :no_such_user | :invalid_user_data
        }

  @components [
    stage(:validate_input),
    done(:done_if_invalid_input),
    switch(
      :token_present?,
      branches: %{
        yes: [
          stage(:find_user_by_token),
          done(:done_if_no_user),
          stage(:find_active_game),
          stage(:find_pending_game_if_no_game),
          goto(:if_there_is_game, to: :prepare_game_data_point)
        ],
        no: [
          stage(:find_users_with_the_name),
          stage(:add_postfix_if_needed),
          stage(:create_user),
          done(:done_if_invalid_user_data),
          stage(:set_token)
        ]
      }
    ),
    stage(:find_free_game),
    switch(
      :is_there_free_game?,
      branches: %{
        yes: [
          stage(:assign_user_to_the_game),
          stage(:activate_game)
        ],
        no: [stage(:create_new_game)]
      }
    ),
    goto_point(:prepare_game_data_point),
    stage(:prepare_game_data)
  ]

  def validate_input(%__MODULE__{username: username, token: token} = event, _) do
    if String.length("#{username}") == 0 and is_nil(token) do
      %{event | error: :invalid_input}
    else
      event
    end
  end

  def done_if_invalid_input(%__MODULE__{error: nil}, _), do: false
  def done_if_invalid_input(%__MODULE__{error: :invalid_input}, _), do: true

  def token_present?(%__MODULE__{token: nil}, _opts), do: :no
  def token_present?(%__MODULE__{token: _token}, _opts), do: :yes

  def find_user_by_token(%__MODULE__{token: token} = event, _opts) do
    case Users.find(token) do
      %User{} = user ->
        %{event | user: user}

      nil ->
        %{event | error: :no_such_user}
    end
  end

  def done_if_no_user(%__MODULE__{error: :no_such_user}, _), do: true
  def done_if_no_user(%__MODULE__{error: nil}, _), do: false

  def find_active_game(%__MODULE__{user: user} = event, _opts) do
    game = Games.active_game_for_user(user.uuid)
    %{event | game: game}
  end

  def find_pending_game_if_no_game(%__MODULE__{user: user, game: nil} = event, _opts) do
    game = Games.pending_game_for_user(user.uuid)
    %{event | game: game}
  end

  def find_pending_game_if_no_game(%__MODULE__{game: _game} = event, _opts), do: event

  def if_there_is_game(%__MODULE__{game: nil}, _opts), do: false
  def if_there_is_game(%__MODULE__{game: %Game{}}, _opts), do: true

  def find_users_with_the_name(%__MODULE__{username: username} = event, _opts) do
    existing_users =
      username
      |> Users.where_name_starts_with()
      |> Enum.map(& &1.name)

    %{event | users_with_the_name: existing_users}
  end

  def add_postfix_if_needed(
        %__MODULE__{users_with_the_name: users_with_the_name, username: username} = event,
        _opts
      ) do
    count = Enum.count(users_with_the_name)

    if count > 0 do
      %{event | username: "#{username}_#{count}"}
    else
      event
    end
  end

  def create_user(%__MODULE__{username: username} = event, _opts) do
    case Users.create(username) do
      {:ok, %User{} = user} ->
        %{event | user: user}

      {:error, _any} ->
        %{event | error: :invalid_user_data}
    end
  end

  def done_if_invalid_user_data(%__MODULE__{error: :invalid_user_data}, _), do: true
  def done_if_invalid_user_data(%__MODULE__{error: nil}, _), do: false

  def set_token(%__MODULE__{user: user} = event, _opts) do
    %{event | token: user.uuid}
  end

  def find_free_game(%__MODULE__{game: nil} = event, _opts) do
    game = Games.find_free_game()
    %{event | game: game}
  end

  def find_free_game(%__MODULE__{game: _game} = event, _opts), do: event

  def is_there_free_game?(%__MODULE__{game: nil}, _opts), do: :no
  def is_there_free_game?(%__MODULE__{game: _game}, _opts), do: :yes

  def assign_user_to_the_game(%__MODULE__{game: game, user: user} = event, _opts) do
    {:ok, game} = Games.assign_second_player(game, user.uuid)
    %{event | game: game}
  end

  def create_new_game(%__MODULE__{game: nil, user: user} = event, _opts) do
    {:ok, %Game{} = game} = Games.create(user.uuid, nil)
    %{event | game: game}
  end

  def activate_game(%__MODULE__{game: game} = event, _opts) do
    {:ok, %Game{} = game} = Games.activate(game)
    %{event | game: game}
  end

  def prepare_game_data(%__MODULE__{game: game} = event, _opts) do
    game_data = Games.game_data(game)
    %{event | game_data: game_data}
  end
end
