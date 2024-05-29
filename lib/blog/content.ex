defmodule Blog.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Blog.Repo

  alias Blog.Content.Post

  def list_posts do
    Post
    |> Repo.all()
    |> Repo.preload(:author)
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def get_my_posts(user_id) do
    from(p in Post, where: p.author_id == ^user_id)
    |> Repo.all()
    |> Repo.preload(:author)
  end

  def create_post(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
