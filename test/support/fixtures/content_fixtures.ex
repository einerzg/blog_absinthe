defmodule Blog.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blog.Content` context.
  """
  import Blog.AccountsFixtures

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        body: "some body",
        published_at: ~N[2024-05-26 20:11:00],
        title: "some title"
      })

    {:ok, post} =
      user_fixture()
      |> Blog.Content.create_post(attrs)

    post
  end
end
