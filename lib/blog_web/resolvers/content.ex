defmodule BlogWeb.Resolvers.Content do
  alias Blog.Content

  def list_posts(_parent, _args, %{context: %{current_user: _user}}) do
    {:ok, Content.list_posts()}
  end

  def list_posts(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def get_my_posts(_parent, _args, %{context: %{current_user: user}}) do
    {:ok, Content.get_my_posts(user.id)}
  end

  def get_my_posts(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def create_post(_parent, args, %{context: %{current_user: user}}) do
    case Content.create_post(user, args) do
      {:ok, post} -> {:ok, Map.put(post, :author, user)}
      {:error, _} -> {:error, "Error creating a post"}
    end
  end

  def create_post(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
