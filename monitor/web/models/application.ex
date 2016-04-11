defmodule Monitor.Application do
  use Monitor.Web, :model

  schema "applications" do
    field :name, :string
    field :app_id, :string

    timestamps
  end

  @required_fields ~w(name app_id)
  @optional_fields ~w()

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
