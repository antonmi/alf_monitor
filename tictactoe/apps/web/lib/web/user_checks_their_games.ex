defmodule Web.UserChecksTheirGames do
  alias Tictactoe.Interfaces.UserChecksTheirGames

  def call(token) do
    case UserChecksTheirGames.call(token) do
      {:ok, result} ->
        result

      {:error, error} ->
        %{error: error}
    end
  end
end
