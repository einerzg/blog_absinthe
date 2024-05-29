defmodule BlogWeb.AuthToken do
  @moduledoc """
  Creates and verifies authentication tokens.
  """
  @salt "any salt"

  def create(user_id) do
    Phoenix.Token.sign(BlogWeb.Endpoint, @salt, user_id)
  end

  def verify(token) do
    Phoenix.Token.verify(BlogWeb.Endpoint, @salt, token, max_age: 60 * 60 * 24)
  end
end
