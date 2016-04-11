defmodule Monitor.Event do
  use Monitor.Web, :model

  schema "events" do
    field :origin, :string
    field :data, :map
    field :type, :string

    timestamps
  end

  @required_fields ~w(origin type)
  @optional_fields ~w(data)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
