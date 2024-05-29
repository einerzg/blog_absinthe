defmodule BlogWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias Blog.Accounts
  alias BlogWeb.AuthToken

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    with {:ok, user_id} <- AuthToken.verify(token),
         user <- Accounts.get_user!(user_id) do
      {:ok, user}
    else
      _ -> {:error, "invalid authorization token"}
    end
  end
end
