defmodule Blog.Accounts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "contacts" do
    field :type, :string
    field :value, :string
    belongs_to :user, Blog.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:type, :value, :user_id])
    |> validate_required([:type, :value, :user_id])
    |> unique_constraint(:value)
  end
end
