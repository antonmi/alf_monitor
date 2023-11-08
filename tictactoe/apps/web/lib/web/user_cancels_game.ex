defmodule Web.UserCancelsGame do
  alias Tictactoe.Interfaces.UserCancelsGame

  def call(uuid, token) do
    case UserCancelsGame.call(uuid, token) do
      {:ok, result} ->
        result

      {:error, error} ->
        %{error: error}
    end
  end
end
