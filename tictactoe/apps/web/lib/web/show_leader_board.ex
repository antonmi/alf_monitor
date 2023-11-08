defmodule Web.ShowLeaderBoard do
  alias Tictactoe.Interfaces.ShowLeaderBoard

  def call() do
    case ShowLeaderBoard.call() do
      {:ok, result} ->
        result

      {:error, error} ->
        %{error: error}
    end
  end
end
