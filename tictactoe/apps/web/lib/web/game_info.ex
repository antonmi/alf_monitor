defmodule Web.GameInfo do
  alias Tictactoe.Interfaces.GameInfo

  def call(uuid) do
    case GameInfo.call(uuid) do
      {:ok, result} ->
        result

      {:error, error} ->
        %{error: error}
    end
  end
end
