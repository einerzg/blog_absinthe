defmodule BlogWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use BlogWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  @endpoint BlogWeb.Endpoint

  using do
    quote do
      # The default endpoint for testing
      @endpoint BlogWeb.Endpoint

      use BlogWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import BlogWeb.ConnCase
    end
  end

  setup tags do
    Blog.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Runs a GraphQL query and checks if there are any errors in the response, returning just the data
  in these cases.
  """
  def run_graphql(conn, query_or_mutation, variables \\ %{}) do
    import Phoenix.ConnTest

    conn
    |> post("/api", %{"query" => query_or_mutation, "variables" => variables})
    |> json_response(200)
    |> case do
      %{"errors" => errors} = response ->
        {:error, Enum.map(errors, &Map.delete(&1, "locations")), response["data"]}

      response ->
        {:ok, response["data"]}
    end
  end

  @doc """
  Adds authentication headers to the given Plug.Conn.
  """
  def authenticated(conn, user_id) do
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{BlogWeb.AuthToken.create(user_id)}")
  end
end
