defmodule Kans.Auth.X do
  @spec validate(binary) :: {:ok, map} | {:error, atom}
  def validate(token) do
    {:ok, %{fake_auth: "accepted (not checked)" <> token}}
  end

  def validate_no_bearer(token_string) do
    {:ok, %{fake_auth: "no_bearer_accepted_not_checked" <> token_string}}
  end
end
