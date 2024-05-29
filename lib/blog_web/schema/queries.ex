defmodule BlogWeb.Schema.Queries do
  use Absinthe.Schema.Notation
  alias BlogWeb.Resolvers

  object :post_queries do
    @desc "Get all posts"
    field :posts, list_of(:post) do
      resolve(&Resolvers.Content.list_posts/3)
    end

    @desc "Get my posts"
    field :get_my_posts, list_of(:post) do
      resolve(&Resolvers.Content.get_my_posts/3)
    end
  end

  object :user_queries do
    @desc "Get a user of the blog"
    field :user, :user do
      resolve(&Resolvers.Accounts.find_user/3)
    end
  end
end
