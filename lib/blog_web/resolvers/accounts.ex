defmodule BlogWeb.Resolvers.Accounts do
  alias Blog.Accounts
  alias BlogWeb.AuthToken

  def find_user(_parent, _args, %{context: %{current_user: user}}) do
    case Accounts.get_user!(user.id) do
      nil ->
        {:error, "User ID #{user.id} not found"}

      user_found ->
        {:ok, user_found}
    end
  end

  def find_user(_parent, _args, _resoluction), do: {:error, message: "Wrong credentials"}

  def create_user(_parent, args, _r) do
    case Accounts.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, _msg} -> {:error, "Error creating a new user"}
    end
  end

  def authenticate_user(_parent, %{username: username, password: password}, _resolution) do
    if user = Accounts.get_user_by_username_and_password(username, password) do
      token = AuthToken.create(user.id)
      {:ok, %{token: token, user: user}}
    else
      {:error, message: "Wrong credentials"}
    end
  end
end
