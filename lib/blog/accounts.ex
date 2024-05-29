defmodule Blog.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Blog.Repo

  alias Blog.Accounts.{User, Contact}

  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:contacts)
  end

  def get_user!(user_id) do
    User
    |> Repo.get!(user_id)
    |> Repo.preload(:contacts)
  end

  def create_user(attrs \\ %{}) do
    {contact_attrs, user_attrs} = Map.pop(attrs, :contact)

    Repo.transaction(fn ->
      with {:ok, user} <- create_simple_user(user_attrs),
           {:ok, contact} <- create_contact(user, contact_attrs) do
        %{user | contacts: [contact]}
      else
        error -> error
      end
    end)
  end

  defp create_simple_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_username_and_password(username, password)
      when is_binary(username) and is_binary(password) do
    user = Repo.get_by(User, username: username)
    if User.valid_password?(user, password), do: user
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def create_contact(user, attrs) do
    user
    |> Ecto.build_assoc(:contacts)
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end
end
