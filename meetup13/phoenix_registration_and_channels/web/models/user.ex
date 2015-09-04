defmodule Swotter.User do
  use Swotter.Web, :model

  schema "users" do
    field :firstname,        :string
    field :lastname,         :string
    field :gender,           :integer
    field :birthdate,        Ecto.Date
    field :language,         :string
    field :crypted_password, :string
    field :salt,             :string
    field :email,            :string
    timestamps
  end

  @required_fields ~w(firstname lastname  email)
  @optional_fields ~w(gender birthdate language crypted_password salt)

  @all_fields @required_fields ++ @optional_fields

  def required_fields, do: @required_fields
  def optional_fields, do: @optional_fields

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end


  # def changeset(model, params \\ :empty) do
  #   model
  #   |> cast(params, [], @all_fields)
  # end


end
