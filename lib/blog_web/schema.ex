defmodule BlogWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(BlogWeb.Schema.AccountTypes)
  import_types(BlogWeb.Schema.ContentTypes)
  import_types(BlogWeb.Schema.Queries)
  import_types(BlogWeb.Schema.Mutations)

  query do
    import_fields(:post_queries)
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:post_mutations)
    import_fields(:user_mutations)
  end
end
