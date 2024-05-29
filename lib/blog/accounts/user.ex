defmodule Blog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :password_hash, :string

    has_many :posts, Blog.Content.Post, foreign_key: :author_id
    has_many :contacts, Blog.Accounts.Contact

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, %{password: password} = attrs) when is_binary(password) do
    new_attrs =
      attrs
      |> Map.put(:password_hash, Bcrypt.hash_pwd_salt(password))

    user
    |> cast(new_attrs, [:username, :password_hash])
    |> validate_required([:username, :password_hash])
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password_hash])
    |> validate_required([:username, :password_hash])
  end

  def valid_password?(%Blog.Accounts.User{password_hash: password_hash}, password)
      when is_binary(password_hash) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, password_hash)
  end
end
