defmodule KansWeb.FallbackController do
  use Phoenix.Controller

  alias Plug.Conn.Status

  require Jason.Helpers
  require Logger

  def call(conn, {:error, :no_route}),
    do: json_error(conn, 404, "Resource not found")

  def call(conn, {:error, :no_token}),
    do: json_error(conn, 401, "Unauthorised")

  defp json_error(conn, code, message), do: json_error(conn, %{code: code, message: message})

  defp json_error(conn, %{code: code, message: message} = error) do
    code = if is_atom(code), do: Status.code(code), else: code

    updated_error =
      Map.put_new(error, :source, get_in(conn, [Access.key!(:private), :phoenix_endpoint]))

    :ok = log_error(updated_error)

    conn
    |> put_status(code)
    |> json(Jason.Helpers.json_map(code: code, message: message))
    |> halt()
  end

  defp log_error(%{code: code, message: message, source: source}) do
    Logger.error("code: #{code}; message #{inspect(message)}; source: #{source}")
  end
end
