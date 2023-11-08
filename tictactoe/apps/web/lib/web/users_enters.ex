defmodule Web.UserEnters do
  alias Tictactoe.Interfaces.UserEnters

  def call(username, token) do
    case UserEnters.call(username, token) do
      {:ok, result} ->
        result

      {:error, error} ->
        %{error: error}
    end
  end
end
