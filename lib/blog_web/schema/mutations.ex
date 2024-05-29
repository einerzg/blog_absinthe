defmodule BlogWeb.Schema.Mutations do
  use Absinthe.Schema.Notation
  alias BlogWeb.Resolvers

  object :post_mutations do
    @desc "Create a post"
    field :create_post, type: :post do
      arg(:title, non_null(:string))
      arg(:body, non_null(:string))
      arg(:published_at, :naive_datetime)

      resolve(&Resolvers.Content.create_post/3)
    end
  end

  object :user_mutations do
    @desc "Create a user"
    field :create_user, :user do
      arg(:username, non_null(:string))
      arg(:contact, non_null(:contact_input))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/3)
    end

    @desc "Auth a user using username and password"
    field :authenticate_user, :session do
      arg(:username, :string)
      arg(:password, :string)

      resolve(&Resolvers.Accounts.authenticate_user/3)
    end
  end
end
