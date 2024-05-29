defmodule Blog.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blog.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: "some username",
        password: "some password",
        contact: %{type: "EMAIL", value: "mail@mail.co"}
      })
      |> Blog.Accounts.create_user()

    user
  end
end
