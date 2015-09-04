defmodule Swotter.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :gender, :integer
      add :birthdate, :date
      add :language, :string
      add :crypted_password, :string
      add :salt, :string
      add :email, :string

      timestamps
    end

    create unique_index(:users, [:email])

  end
end
