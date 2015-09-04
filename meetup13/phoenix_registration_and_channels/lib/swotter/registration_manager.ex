defmodule Swotter.RegistrationManager do

  alias Ecto.Changeset, as: E

  alias Swotter.User

  def register_user(params) do

    params
    |> make_changeset
    |> unique_constraint
    |> validate_password_confirmation(params)
    |> downcase_email
    |> hash_password
    |> insert

  end

  defp make_changeset(params) do
    E.cast(
      %User{},
      params,
      [:crypted_password | User.required_fields],
      User.optional_fields
    )
  end


  defp unique_constraint(changeset) do
    E.unique_constraint(changeset, :email)
  end


  defp validate_password_confirmation(changeset, params) do
    pwd = E.get_field(changeset, :crypted_password)

    if params["crypted_password_confirmation"] == pwd do
      {:ok, changeset}
    else
      changeset = E.add_error(changeset, :crypted_password, "Passwords do not match")
      {:error, add_action(changeset)}
    end
  end



  defp hash_password({:error, changeset}), do: {:error, changeset}
  defp hash_password({:ok, changeset}) do

    if password = E.get_field(changeset, :crypted_password) do

      salt  = Swotter.Crypto.generate_random_salt

      crypted_password = Swotter.Crypto.hash_password(salt, password)

      changeset = changeset
      |> E.put_change(:crypted_password, crypted_password)
      |> E.put_change(:salt, salt)

    end

    {:ok, changeset }
  end

  defp insert({:error, changeset}), do: {:error, changeset}
  defp insert({:ok, changeset}) do

    if changeset.valid? do

      case Swotter.Repo.insert(changeset) do
        {:ok, user}         ->
          {:ok,    changeset, user}

        {:error, changeset} ->

          {:error, changeset}
      end

    else
        {:error,  add_action(changeset)}
    end
  end



  defp downcase_email({:error, changeset}), do: {:error, changeset}

  defp downcase_email({:ok, changeset}) do
    email = E.get_field(changeset, :email)

    if is_binary(email) do
      changeset = E.put_change(changeset, :email, String.downcase(email))
    end

    {:ok, changeset}
  end


  defp add_action(changeset), do: %{changeset | action: :insert}

end
