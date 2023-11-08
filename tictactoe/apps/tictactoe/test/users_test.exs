defmodule Tictactoe.UsersTest do
  use Tictactoe.DataCase

  alias Tictactoe.Users

  describe "create/1" do
    test "success case" do
      {:ok, user} = Users.create("john")
      assert user.name == "john"
    end

    test "when name is blank" do
      {:error, changeset} = Users.create("")
      assert changeset.errors == [name: {"can't be blank", [validation: :required]}]
    end
  end

  describe "where_name_starts_with/1" do
    setup do
      {:ok, _user} = Users.create("john")
      {:ok, _user} = Users.create("john_2")
      {:ok, _user} = Users.create("john_3")
      {:ok, _user} = Users.create("jack")
      :ok
    end

    test "it returns all the johns" do
      users = Users.where_name_starts_with("john")
      assert Enum.count(users) == 3

      users = Users.where_name_starts_with("JohN")
      assert Enum.count(users) == 3
    end
  end

  describe "increase_scores/2" do
    setup do
      {:ok, user} = Users.create("john")
      %{user: user}
    end

    test "new value", %{user: user} do
      {:ok, user} = Users.increase_scores(user, 3)
      assert user.scores == 3
    end
  end
end
