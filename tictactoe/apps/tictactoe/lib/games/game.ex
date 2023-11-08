defmodule Tictactoe.Game do
  alias Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  alias Tictactoe.{Game, Move}

  @statuses ["pending", "active", "victory", "draw", "cancelled"]

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "games" do
    field(:field, {:array, :integer}, default: [nil, nil, nil, nil, nil, nil, nil, nil, nil])
    field(:user_x_uuid, :binary_id)
    field(:user_o_uuid, :binary_id)
    field(:turn_uuid, :binary_id)
    field(:status, :string, default: "pending")

    timestamps()
  end

  def changeset(game, attrs \\ %{}) do
    game
    |> Changeset.cast(attrs, [:field, :user_x_uuid, :user_o_uuid, :turn_uuid, :status])
    |> Changeset.validate_required([:field, :user_x_uuid, :turn_uuid])
    |> Changeset.validate_inclusion(:status, @statuses)
  end

  @spec validate_move(Game.t(), Move.t()) ::
          :ok
          | {:error, :not_your_turn}
          | {:error, :position_outside_range}
          | {:error, :square_is_taken}
  def validate_move(%Game{} = game, %Move{} = move) do
    with :ok <- validate_turn(game, move),
         :ok <- validate_position(move),
         :ok <- validate_square(game, move) do
      :ok
    end
  end

  @spec apply_move(Game.t(), Move.t()) :: Game.t()
  def apply_move(game, move) do
    number = number_to_put_on_the_field(game)
    new_field = List.update_at(game.field, move.position, fn nil -> number end)

    %{game | field: new_field}
  end

  @spec check_game_status(Game.t()) :: :continue | :victory | :draw
  def check_game_status(game) do
    with :nope <- check_victory(game),
         :nope <- check_draw(game) do
      "active"
    end
  end

  defp validate_turn(%Game{turn_uuid: turn_uuid}, %Move{user_uuid: user_uuid}) do
    if turn_uuid == user_uuid, do: :ok, else: {:error, :not_your_turn}
  end

  defp validate_position(%Move{position: position}) do
    if position in 0..8, do: :ok, else: {:error, :position_outside_range}
  end

  defp validate_square(%Game{field: field}, %Move{position: position}) do
    in_position = Enum.at(field, position)

    if is_nil(in_position), do: :ok, else: {:error, :square_is_taken}
  end

  def toggle_turn(
        %Game{turn_uuid: turn_uuid, user_x_uuid: user_x_uuid, user_o_uuid: user_o_uuid} = game
      ) do
    case turn_uuid do
      ^user_x_uuid ->
        %{game | turn_uuid: user_o_uuid}

      ^user_o_uuid ->
        %{game | turn_uuid: user_x_uuid}
    end
  end

  defp number_to_put_on_the_field(%Game{
         turn_uuid: turn_uuid,
         user_x_uuid: user_x_uuid,
         user_o_uuid: user_o_uuid
       }) do
    case turn_uuid do
      ^user_x_uuid -> 1
      ^user_o_uuid -> 0
    end
  end

  defp check_victory(%Game{field: field}) do
    matrix = Enum.chunk_every(field, 3)
    any_row? = Enum.any?(matrix, &(Enum.uniq(&1) in [[0], [1]]))
    any_column? = Enum.any?(transpose(matrix), &(Enum.uniq(&1) in [[0], [1]]))

    any_diagonal? =
      [
        [Enum.at(field, 0), Enum.at(field, 4), Enum.at(field, 8)],
        [Enum.at(field, 2), Enum.at(field, 4), Enum.at(field, 6)]
      ]
      |> Enum.any?(&(Enum.uniq(&1) in [[0], [1]]))

    if any_row? or any_column? or any_diagonal?, do: "victory", else: :nope
  end

  defp check_draw(%Game{field: field}) do
    flattened = List.flatten(field)
    any_nil? = nil in Enum.uniq(flattened)
    if any_nil?, do: :nope, else: "draw"
  end

  defp transpose([[] | _]), do: []

  defp transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end
end
