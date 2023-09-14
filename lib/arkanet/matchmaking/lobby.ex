defmodule Arkanet.Matchmaking.Lobby do
  use Arkanet.Schema
  import Ecto.Changeset

  schema "lobbies" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(lobby, attrs) do
    lobby
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
