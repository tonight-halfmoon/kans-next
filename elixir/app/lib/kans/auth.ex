defmodule Kans.Auth do
  alias Kans.Auth.X

  def validate_x("Bearer " <> token), do: X.validate(token)
  def validate_x(token), do: X.validate_no_bearer(token)
end
